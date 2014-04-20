define [
  'marionette'
  'client/router'
  'client/controller'
], (Marionette, Router, Controller) ->

  App = new Marionette.Application()

  App.navigate = (route, options) ->
    options or= {}
    Backbone.history.navigate(route, options)

  App.addInitializer ->
    controller = new Controller
    @router = new Router(controller: controller)

  App.on 'initialize:after', ->
    Backbone.history.start
      pushState: true
      root: '/'

    $(document).on 'click', '.js-link', (event) ->
      event.preventDefault()
      href = $(event.currentTarget).attr('href')
      App.navigate(href, trigger: true)

    $(document).foundation()

    console.log 'app started'

  App
