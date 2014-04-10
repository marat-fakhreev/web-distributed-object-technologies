# requirejs = require('requirejs')

# requirejs.config
#   nodeRequire: require

# requirejs [
#   'express'
#   'http'
#   'redis'
#   'socket.io'
#   'underscore'
# ], (express, http, redis, SocketIo, _) ->

express = require('express')
http = require('http')
redis = require('redis')
socketIo = require('socket.io')
_ = require('underscore')

app = express()
server = http.createServer(app)
io = socketIo.listen(server, log: false)
redisClient = redis.createClient()

app.get '/', (req, res) ->
  res.sendfile __dirname + '/index.html'

storeMessage = (name, message) ->
  message = JSON.stringify(name: name, message: message)

  redisClient.lpush 'messages', message, (error, response) ->
    redisClient.ltrim('messages', 0, 9)

io.sockets.on 'connection', (client) ->
  client.on 'join', (name) ->
    console.log "#{name} connected the chat"
    user = name
    client.set 'nickname', name, ->
      client.emit('user connected', user)
      client.emit('user add_to_chat_list', user)
      client.broadcast.emit('user connected_for_all', user)
      client.broadcast.emit('user add_to_chat_list', user)

      redisClient.lrange 'messages', 0, -1, (error, messages) ->
        messages = messages.reverse()

        _.each messages, (data, index) ->
          data = JSON.parse(data)
          client.emit('chat', data)

      redisClient.smembers 'users', (error, users) ->
        _.each users, (name, index) ->
          client.emit('user add_to_chat_list', name)

      redisClient.sadd('users', name)

  client.on 'disconnect', (name) ->
    client.get 'nickname', (error, name) ->
      client.broadcast.emit('user remove_from_chat_list', name)
      redisClient.srem('users', name)

  client.on 'messages', (message) ->
    client.get 'nickname', (error, name) ->
      data =
        name: name
        message: message

      client.emit('chat', data)
      client.broadcast.emit('chat', data)
      storeMessage(name, message)

exports = module.exports = server

# delegates use() function
exports.use = ->
  app.use.apply(app, arguments)
