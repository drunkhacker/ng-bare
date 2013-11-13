'use strict'

livereload_port = 35729
lrSnippet = require('connect-livereload') port: livereload_port
#accessAllow = (req, res, next) ->
  #res.setHeader 'Access-Control-Allow-Origin', '*'
  #res.setHeader 'Access-Control-Allow-Methods', '*'
  #next()

mountFolder = (connect, dir) ->
  connect.static require('path').resolve dir

module.exports = (grunt) ->
  # show elapsed time at the end
  require('time-grunt') grunt
  # load all grunt tasks
  require('load-grunt-tasks') grunt

  grunt.initConfig
    # configurable paths
    watch:
      options:
        livereload: true
      coffee:
        files: ['app/scripts/**/*.coffee']
        tasks: 'coffee'
        options:
          livereload: false
      less:
        files: ['app/styles/**/*.less']
        tasks: 'less'
        options:
          livereload: false
      scripts:
        files: '{.tmp,app}/scripts/**/*.js'
      imgs:
        files: 'app/images/**/*.{png,jpg,jpeg,gif,webp,svg}'
      styles:
        files: ['{.tmp,app}/styles/**/*.css']
      html:
        files: ['{app,.tmp}/views/*.html', '{app,.tmp}/index.html']
      jade:
        files:
          ['app/views/**/*.jade', 'app/index.jade']
        tasks: 'jade'
        options:
          livereload: false
    connect:
      options:
        port: 9000
        hostname: '*'
      livereload:
        options:
          middleware: (connect) ->
            [ lrSnippet, mountFolder(connect, '.tmp'), mountFolder(connect, 'app')]
    clean: ['.tmp']
    coffee:
      compile:
        files: [
            '.tmp/scripts/app.js' : 'app/scripts/app.coffee'
            '.tmp/scripts/controllers.js' : 'app/scripts/controllers/*.coffee'
          ,
            expand: true
            cwd: 'app/scripts/services'
            src: '**/*.coffee'
            dest: '.tmp/scripts/services'
            ext: '.js'
        ]
    concat:
      server:
        files: ".tmp/scripts/services.js": ['app/scripts/services/services.js', '.tmp/scripts/services/*.js']
    less:
      compile: 
        files: [
          expand: true
          cwd: 'app/styles/'
          src: '**/*.coffee'
          dest: '.tmp/styles/'
          ext: 'css'
        ]
    jade:
      compile:
        files: [
            expand: true
            cwd: 'app/'
            src: '**/*.jade'
            dest: '.tmp/'
            ext: '.html'
        ]
    concurrent: 
      server: ['coffee', 'less', 'jade']

  grunt.registerTask 'server', [ 'clean', 'concurrent:server', 'concat', 'connect:livereload', 'watch' ]
