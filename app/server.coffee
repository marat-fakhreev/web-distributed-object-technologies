requirejs = require('requirejs')
express = require('express')
http = require('http')

app = express(app)
server = http.createServer(app)

requirejs.config
  baseUrl: 'public/scripts/server'
  nodeRequire: require

requirejs [
  'chat'
], (Chat) ->

  new Chat(app, server)

exports = module.exports = server

exports.use = ->
  app.use.apply(app, arguments)
