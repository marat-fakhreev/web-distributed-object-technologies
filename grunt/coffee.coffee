module.exports = (grunt) ->
  options:
    bare: true
  development:
    files: [
      expand: true
      cwd: '<%= grunt.appDir %>'
      src: ['*.coffee', '**/*.coffee']
      dest: '<%= grunt.publicDir %>'
      ext: '.js'
    ]
  watch:
    files: {}
