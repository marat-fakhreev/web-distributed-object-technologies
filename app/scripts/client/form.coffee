define [
  'marionette',
  'client/chat'
], (Marionette, Chat) ->

  class Form
    constructor: (@chat) ->
      @ui()
      @_events()
      @state = false

    ui: ->
      @$usersItem = $('#users-item')
      @$chatItem = $('#chat-item')
      @$form = $('#form')
      @$chat = $('#chat')
      @$users = $('#users')
      @$list = $('#list')

    _events: ->
      @$form.on 'submit', (event) =>
        event.preventDefault()
        user = @_createObject()
        @flag = true
        @chat.socket.emit('join', user)
        @$form.fadeOut 300, =>
          @$chat.fadeIn(300)

      @$usersItem.on 'click', =>
        @$form.fadeOut(300)
        @$chat.fadeOut 300, =>
          @$users.fadeIn 300, =>
            @$list.empty()
            @chat.socket.emit('list')

      @$chatItem.on 'click', =>
        @$users.fadeOut 300, =>
          if @flag
            @$chat.fadeIn 300
            @$form.fadeOut 300
          else
            @$chat.fadeOut 300
            @$form.fadeIn 300

      @chat.socket.on 'user add_to_list', (user) =>
        user = JSON.parse(user)
        @$list.append("""
          <tr style=color:#{user.color}>
            <td>#{user.name}</td>
            <td>#{user.nickname}</td>
            <td>#{user.site}</td>
            <td>#{user.color}</td>
          </tr>
        """)

    _createObject: ->
      user =
        nickname: @$form.find('#nickname').val()
        name: @$form.find('#name').val()
        site: "#{@$form.find('#site').val()}.com"
        color: @$form.find('.color-item:checked').val()

      JSON.stringify(user)
