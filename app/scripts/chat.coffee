define [
  'marionette'
], (Marionette) ->

  class Chat
    constructor: ->
      @socket = io.connect('http://localhost:8000')
      @socketEvents()
      @appEvents()

    resetSettings: ->
      $('.chat-list').html('')

    socketEvents: ->
      @socket.on 'chat', (data) ->
        $('.chat-window')
          .append("<li><span class='name'>#{data.name}:</span>#{data.message}</li>")
          .scrollTop(500)
        $('#msg_field').val('')

      @socket.on 'user connected', (name) ->
        $('#status').html("Your status: <span class='online'>Online</span>, Name: #{name}")

      @socket.on 'user connected_for_all', (name) ->
        $('.chat-window').append("<li>#{name} joined the chat</li>")

      @socket.on 'user add_to_chat_list', (name) ->
        $('.chat-list').append("<li data-name=#{name}>#{name}</li>")

      @socket.on 'user remove_from_chat_list', (name) ->
        $(".chat-list li[data-name=#{name}]").remove()
        $('.chat-window').append("<li>#{name} has left the chat</li>")

      @socket.on 'connect', (data) =>
        nickname = prompt('Your name is?')
        @resetSettings()
        @socket.emit('join', nickname)

    appEvents: ->
      $('#send').on 'click', @onSendMessage
      $('#msg_field').on 'keydown', @onSendMessageWithKey

    onSendMessage: =>
      msg = $('#msg_field').val()
      @socket.emit 'messages', msg

    onSendMessageWithKey: (event) =>
      @onSendMessage() if event.keyCode is 13
