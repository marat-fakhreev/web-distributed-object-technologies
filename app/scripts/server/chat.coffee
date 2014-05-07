define [
  'socket.io'
  'dnode'
  'underscore'
], (SocketIo, Rpc, _) ->

  class Chat
    constructor: (@app, @server, @redisClient) ->
      @io = SocketIo.listen(@server, log: false)

      @app.get '/', (req, res) ->
        res.sendfile __dirname + '/index.html'

      @socketEvents()

      @rpcInit()

    socketEvents: ->
      @io.sockets.on 'connection', (client) =>
        @client = client
        color = 'black'

        client.on 'join', (object) =>
          o = JSON.parse(object)
          name = o.nickname
          color = o.color

          client.set 'nickname', name, => @onUserConnect(object)
          console.log "#{name} connected the chat"

        client.on 'disconnect', (name) =>
          client.get 'nickname', (error, name) => @onUserDisconnect(error, name)

        client.on 'messages', (message) =>
          client.get 'nickname', (error, name) => @onSendMessage(error, name, message, color)

        client.on 'list', => @onGetUsersList()

    rpcInit: ->
      rpc = Rpc.connect(5004)
      text = 'Users at the chat:'

      rpc.on 'remote', (remote) ->
        remote.showUsers text, (userList) ->
          console.log userList
          rpc.end()

        remote.showCount (userCount) ->
          console.log "USERS COUNT IS: #{userCount}"
          rpc.end()

    onUserConnect: (object) ->
      user = JSON.parse(object)
      @client.emit('user connected', user.nickname)
      @client.broadcast.emit('user connected_for_all', user.nickname)
      @client.broadcast.emit('user add_to_chat_list', user.nickname, user.color)

      #save user to database
      @redisClient.sadd('users', object)
      @redisClient.lrange 'messages', 0, -1, (error, messages) => @onRedisAddMessage(error, messages)
      @redisClient.smembers 'users', (error, users) => @onRedisAddUsersToChatList(error, users)

      #get all user with remote procudure calling
      @rpcInit()

    onUserDisconnect: (error, name, message) ->
      @client.broadcast.emit('user remove_from_chat_list', name)
      @redisClient.srem('users', name)

    onSendMessage: (error, name, message, color) ->
      data =
        name: name
        color: color
        message: message

      console.log data

      @client.emit('chat', data)
      @client.broadcast.emit('chat', data)
      @_redisStoreMessage(name, color, message)

    onRedisAddMessage: (error, messages) ->
      messages = messages.reverse()

      _.each messages, (data, index) =>
        data = JSON.parse(data)
        @client.emit('chat', data)

    onRedisAddUsersToChatList: (error, users) ->
      _.each users, (user, index) =>
        user = JSON.parse(user)
        @client.emit('user add_to_chat_list', user.nickname, user.color)

    onGetUsersList: ->
      @redisClient.smembers 'users', (error, users) =>
        _.each users, (user, index) =>
          @client.emit('user add_to_list', user)

    _redisStoreMessage: (name, color, message) ->
      message =
        name: name
        color: color
        message: message

      message = JSON.stringify(message)

      @redisClient.lpush 'messages', message, (error, response) =>
        @redisClient.ltrim('messages', 0, 9)
