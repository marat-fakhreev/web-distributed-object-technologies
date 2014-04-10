requirejs = require('requirejs')

requirejs.config
  baseUrl: 'scripts/server'
  nodeRequire: require

requirejs [
  'chat'
], (chat) ->

  exports = module.exports = chat.server

  # chat.app.listen(8000)

  # # delegates use() function
  # exports.use = ->
  #   app = chat.app
  #   app.use.apply(app, arguments)
