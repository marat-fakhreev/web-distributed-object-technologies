module.exports = (grunt) ->
  grunt.registerTask 'server', (target) ->
    if target is 'development'
      grunt.task.run [
        'express:development'
        'watch:development'
      ]
    else if target is 'production'
      grunt.task.run [
        'connect:production'
        'easymock'
        'configureProxies:server'
        'watch:production'
      ]
