define [
  'marionette'
  'application'
  'client/chat'
  'client/form'
], (Marionette, App, Chat, Form) ->

  class Controller extends Marionette.Controller
    index: ->
      chat = new Chat()
      form = new Form(chat)
