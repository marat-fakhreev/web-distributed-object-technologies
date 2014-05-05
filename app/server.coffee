requirejs = require('requirejs')
express = require('express')
http = require('http')
redis = require('redis')

app = express(app)
server = http.createServer(app)

requirejs.config
  baseUrl: 'public/scripts'
  nodeRequire: require

requirejs [
  'rpc-server/rpc_server'
  'server/chat'
], (RpcServer, Chat) ->
  redisClient = redis.createClient()

  new RpcServer(redisClient)
  new Chat(app, server, redisClient)

exports = module.exports = server

exports.use = ->
  app.use.apply(app, arguments)
