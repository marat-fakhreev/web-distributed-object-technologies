module.exports = (grunt) ->
  grunt.event.on 'watch', (action, filepath) ->
    file = {}

    if /(.coffee)/.test filepath
      dest = filepath.replace("#{grunt.appDir}", "#{grunt.publicDir}").replace('.coffee', '.js')
      file[dest] = filepath
      grunt.config 'coffeelint.watch.files', file
      grunt.config 'coffee.watch.files', file
    else if /(.styl)/.test filepath
      dest = "#{grunt.publicDir}/stylesheets/style.css"
      file[dest] = "#{grunt.appDir}/stylesheets/application.styl"
      grunt.config 'stylus.watch.files', file
    else if /(.jade)/.test filepath
      dest = "#{grunt.publicDir}/scripts/templates.js"
      file[dest] = "#{grunt.appDir}/templates/**/*.jade"
      grunt.config 'jade.watch.files', file

  options:
    spawn: false
    livereload: true
  development:
    files: [
      '<%= grunt.appDir %>/**/*'
    ]
    tasks: [
      'jade:html'
      'targethtml:development'
      'jade:watch'
      'stylus:watch'
      'coffee:watch'
      'coffeelint:watch'
      'notify:watch'
    ]
  production:
    files: []
