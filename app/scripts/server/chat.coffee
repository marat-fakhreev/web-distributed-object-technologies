define [
  'redis'
  'socket.io'
  'underscore'
], (Redis, SocketIo, _) ->

  class Chat
    constructor: (@app, @server) ->
      @redisClient = Redis.createClient()
      @io = SocketIo.listen(@server, log: false)

      @app.get '/', (req, res) ->
        res.sendfile __dirname + '/index.html'

      @socketEvents()

    socketEvents: ->
      @io.sockets.on 'connection', (client) =>
        @client = client

        client.on 'join', (name) =>
          console.log "#{name} connected the chat"
          user = name
          client.set 'nickname', name, => @onUserConnect(user)

        client.on 'disconnect', (name) =>
          client.get 'nickname', (error, name) => @onUserDisconnect(error, name)

        client.on 'messages', (message) =>
          client.get 'nickname', (error, name) => @onSendMessage(error, name, message)

    onUserConnect: (userName) ->
      @client.emit('user connected', userName)
      @client.emit('user add_to_chat_list', userName)
      @client.broadcast.emit('user connected_for_all', userName)
      @client.broadcast.emit('user add_to_chat_list', userName)

      @redisClient.lrange 'messages', 0, -1, (error, messages) => @onRedisAddMessage(error, messages)
      @redisClient.smembers 'users', (error, users) => @onRedisAddUsersToChatList(error, users)
      @redisClient.sadd('users', userName)

    onUserDisconnect: (error, name, message) ->
      @client.broadcast.emit('user remove_from_chat_list', name)
      @redisClient.srem('users', name)

    onSendMessage: (error, name) ->
      data =
        name: name
        message: message

      @client.emit('chat', data)
      @client.broadcast.emit('chat', data)
      @_redisStoreMessage(name, message)

    onRedisAddMessage: (error, messages) ->
      messages = messages.reverse()

      _.each messages, (data, index) =>
        data = JSON.parse(data)
        @client.emit('chat', data)

    onRedisAddUsersToChatList: (error, users) ->
      _.each users, (name, index) =>
        @client.emit('user add_to_chat_list', name)

    _redisStoreMessage: (name, message) ->
      message = JSON.stringify(name: name, message: message)

      @redisClient.lpush 'messages', message, (error, response) =>
        @redisClient.ltrim('messages', 0, 9)
