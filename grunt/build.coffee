module.exports = (grunt) ->
  grunt.registerTask 'build', (target) ->
    if target is 'development'
      grunt.task.run [
        'clean:development'
        'symlink:development'
        'jade:jst'
        'stylus:development'
        'coffee:development'
        'coffeelint:development'
        'jade:html'
        'targethtml:development'
      ]
    else if target is 'production'
      grunt.task.run [
        'clean:development'
        'symlink:development'
        'jade:jst'
        'stylus:development'
        'coffee:development'
        'coffeelint:development'
        'clean:production'
        'jade:production'
        'targethtml:production'
        'cssmin:production'
        'requirejs:production'
      ]
