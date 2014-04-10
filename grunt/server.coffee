module.exports = (grunt) ->
  grunt.registerTask 'server', (target) ->
    if target is 'development'
      grunt.task.run [
        'express:development'
        'watch:development'
      ]
