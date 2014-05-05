define [
  'redis'
  'socket.io'
  'dnode'
  'underscore'
], (Redis, SocketIo, Rpc, _) ->

  class RpcServer
    constructor: (@redisClient) ->
      server = Rpc
        showUsers: (variable, callback) =>
          @getUsersList(variable, callback)

      server.listen(5004)

    getUsersList: (variable, callback) ->
      @redisClient.smembers 'users', (error, users) ->
        array = []
        array.push(['', '', variable, ''])

        _.each users, (user, index) ->
          array.push(user)

        list = _.flatten(array)

        callback(list.join("\n"))
