define [
  'marionette'
  'application'
], (Marionette, App) ->

  class Router extends Marionette.AppRouter
    appRoutes:
      '': 'index'
