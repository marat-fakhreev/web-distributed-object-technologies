define [
  'marionette'
], (Marionette) ->

  class Chat
    constructor: ->
      @socket = io.connect('http://localhost:8000')
      @socket_events()
      @app_events()

    socket_events: ->
      @socket.on 'chat', (data) ->
        $('.chat-window').append("<p>#{data}</p>")

      @socket.on 'ready', (name) ->
        $('#status').html("Your status: Online, Name: #{name}")

      @socket.on 'notify other', (name) ->
        $('.chat-window').append("<p>#{name} joined the chat</p>")

      @socket.on 'connect', (data) =>
        nickname = prompt('Your name is?')
        @socket.emit('join', nickname)

    app_events: ->
      $('#send').on 'click', (event) =>
        self = $(event.currentTarget)
        msg = $('#msg_field').val()
        @socket.emit 'messages', msg, ->
          $('#msg_field').val('')
