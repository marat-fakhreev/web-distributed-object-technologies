app = require('express')()
server = require('http').createServer(app)
io = require('socket.io').listen(server, log: false)
_ = require('underscore')

app.get '/', (req, res) ->
  res.sendfile __dirname + '/index.html'

messages = []

storeMessage = (name, message) ->
  messages.push(name: name, message: message)
  messages.shift() if messages.length > 10

io.sockets.on 'connection', (client) ->
  console.log 'client connected'

  client.on 'join', (name) ->
    user = name
    client.set 'nickname', name, ->
      client.emit('ready', user)
      client.broadcast.emit('notify other', user)

      _.each messages, (data, index) ->
        client.emit('chat', "#{data.name}: #{data.message}")

  client.on 'messages', (message) ->
    client.get 'nickname', (err, name) ->
      client.emit('chat', "#{name}: #{message}")
      client.broadcast.emit('chat', "#{name}: #{message}")
      storeMessage(name, message)

exports = module.exports = server

# delegates use() function
exports.use = ->
  app.use.apply(app, arguments)
