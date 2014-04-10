requirejs = require('requirejs')
express = require('express')
http = require('http')

app = express()
server = http.createServer(app)

requirejs.config
  baseUrl: 'public/scripts/server'
  nodeRequire: require

requirejs [
  'chat'
], (chat) ->

  chat(app, server)

# delegates use() function

exports = module.exports = server

exports.use = ->
  app.use.apply(app, arguments)
