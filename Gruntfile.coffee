module.exports = (grunt) ->

  # Use environment to determine stylesheet output parameters
  compassTask = "compass:#{(grunt.option 'env') ? 'debug'}"

  compassOptions = (options) ->
    grunt.util._.extend {}, defaultCompassOptions, options

  watchOptions = (options) ->
    grunt.util._.extend {}, defaultWatchOptions, options

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      options:
        bare: true
        sourceMap: false
        umd: true
      compile:
        expand: true
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'static/javascripts/'
        ext: '.js'

    eco:
      options:
        umd: true
      compile:
        expand: true
        cwd: 'src/'
        src: ['**/*.eco']
        dest: 'static/javascripts/'
        ext: '.js'

    compass:
      production:
        options: compassOptions
          environment: 'production'
          outputStyle: 'compressed'
          noLineComments: true
      debug:
        options: compassOptions
          outputStyle: 'nested'
          debugInfo: true

    requirejs:
      compile:
        options:
          name: 'dr-puzzle/app'
          out: './static/apps/dr-puzzle.js'
          baseUrl: './static/javascripts/vendor'
          paths:
            'dr-puzzle': '../dr-puzzle'
            'sounds': '../../sounds'
            'requireJS': 'require'
          shim: {}
          include: ['requireJS', 'text']
          preserveLicenseComments: false

    watch:
      coffee:
        files: 'src/**/*.coffee'
        tasks: ['newer:coffee']
        options: watchOptions()
      eco:
        files: 'src/**/*.eco'
        tasks: ['newer:eco']
        options: watchOptions()
      compass:
        files: ['style/**/*.s[ac]ss', '**/*.{png,jpg,gif,svg,ttf}']
        tasks: [compassTask]
        options: watchOptions()
      static:
        files: ['static/**/*.{js,css}']
        options: (watchOptions livereload: true)

    clean:
      static:
        src: ['static/**/*']
        filter: isStaticFileGenerated

  # Community tasks
  grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  # Overridden community tasks
  # grunt.loadNpmTasks 'grunt-contrib-coffee'
  # grunt.loadNpmTasks 'grunt-eco-amd'

  # Flamingo tasks
  grunt.loadTasks './tasks'

  grunt.registerTask 'build', [
    'newer:coffee'
    'newer:eco'
    compassTask
  ]

  grunt.registerTask 'develop', [
    'build'
    'watch'
  ]

  grunt.registerTask 'release', [
    'build'
    'requirejs'
  ]

  return

# Default options helper for compass tasks
defaultCompassOptions =
  force: true
  sassDir: 'style'
  cssDir: 'static/stylesheets'
  imagesDir: 'static/images'
  javascriptsDir: 'static/javascripts'
  fontsDir: 'static/fonts'

# Default options helper for watch tasks
defaultWatchOptions =
  interval: 2000

# Helper for clean task to only remove generated files
isStaticFileGenerated = (filename) ->
  (/^static\/(apps|javascripts|stylesheets)\//.test filename) and
  (not /^static\/(javascripts|stylesheets)\/vendor/.test filename)
