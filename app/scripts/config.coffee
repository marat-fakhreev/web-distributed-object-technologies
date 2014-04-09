requirejs.config
  baseUrl: '/scripts'
  nodeRequire: require
  paths:
    'underscore': '../bower_components/underscore/underscore'
    'jquery': '../bower_components/jquery/jquery'
    'backbone': '../bower_components/backbone/backbone'
    'marionette': '../bower_components/marionette/lib/backbone.marionette'
    'foundation': '../bower_components/foundation/js/foundation'
    'modernizr': '../bower_components/modernizr/modernizr'

    'jade': '../vendor/scripts/runtime'
  shim:
    'underscore':
      exports: '_'
    'jquery':
      exports: '$'
    'backbone':
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    'marionette':
      deps: ['backbone', 'foundation']
      exports: 'Marionette'
    'foundation':
      deps: ['jquery', 'modernizr']
    'templates':
      deps: ['jade']
