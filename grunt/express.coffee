module.exports = (grunt) ->
  options: {}

  development:
    options:
      port: 8000
      bases: '<%= grunt.publicDir %>'
      server: '<%= grunt.publicDir %>/server.js'
      livereload: '<%= grunt.ports.livereload %>'
      # showStack: true
      # serverreload: true
