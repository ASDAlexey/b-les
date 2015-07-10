gulp = require('gulp')
plumber = require('gulp-plumber')
coffee = require('gulp-coffee')
sourcemaps = require('gulp-sourcemaps')
uglify = require('gulp-uglify')
imagemin = require('gulp-imagemin')
pngquant = require('imagemin-pngquant')
spritesmith = require('gulp.spritesmith')
sass = require('gulp-sass')
prefix = require('gulp-autoprefixer')
please = require('gulp-pleeease')
jade = require('gulp-jade')
util = require("util")
data = require('gulp-data')
stylus = require('gulp-stylus')
scandir = require('scandir')
connect = require('gulp-connect')
gutil = require('gulp-util')
htmlmin = require('gulp-htmlmin')
purify = require('gulp-purifycss')
minifyCss = require('gulp-minify-css')
gulp.task 'purify-css', ->
  gulp.src('./app/styles/application.css').pipe(purify([
    './app/bundle.js'
    './app/*.html'
  ])).pipe(minifyCss()).pipe gulp.dest('./app/styles/')
gulp.task 'minifyHTML', ->
  gulp.src('./app/*.html').pipe(htmlmin(collapseWhitespace: true)).pipe gulp.dest('./app/')
gulp.task 'imagemin',->
  gulp.src('./app/images/**/*').pipe(imagemin(
    progressive : true
    svgoPlugins : [{removeViewBox : false}]
    use : [pngquant()])).pipe gulp.dest('./app/images')
gulp.task 'coffee',->
  gulp.src('./app/scripts/**/*.coffee')
  .pipe(plumber(errorHandler : (error,file) ->
      console.log error.message
      @emit 'end'
    ))
  .pipe(sourcemaps.init())
  .pipe(coffee(bare : false))
#  .pipe(uglify())
  .pipe(sourcemaps.write('./'))
  .pipe gulp.dest('./app/scripts/')
  .pipe(connect.reload())
gulp.task 'watchConsole',->
  exec = require('child_process').exec
  watch = require('gulp-watch')
  watch './app/images/**/*.{jpg,jpeg,png,gif}',->
    exec 'chmod 755 -R ./app/images'
gulp.task 'stylus',->
  gulp.src('./app/styles/application.styl')
  .pipe(plumber(errorHandler : (error,file) ->
      console.log error.message
      @emit 'end'
    ))
  .pipe(stylus(
      'include css' : true
      sourcemap :
        inline : true
        sourceRoot : '.'
        basePath : './app/styles'
    ))
  .pipe(please(
      'minifier' : true
      "autoprefixer" : {
        'browsers' : [
          'last 6 versions'
          'Android 4'
          'ie 9'
          'ie 10'
          'ie 11'
        ]
      },
      'filters' : true
      'oldIE' : true
      'rem' : true
      'pseudoElements' : true
      'opacity' : true
      'import' : true
      'mqpacker' : true
      'next' : true,
      preserveHacks : true,
      removeAllComments : true
      sourcemaps : true
    ))
  .pipe gulp.dest('./app/styles')
  .pipe(connect.reload())
gulp.task 'sprite',->
  spriteData = gulp.src('./app/images/sprite/*.*').pipe(spritesmith(
    imgName : '../images/sprite.png'
    cssName : 'utilities/_sprite.styl'
    padding : 4))
  spriteData.img.pipe gulp.dest('./app/images/')
  spriteData.css.pipe gulp.dest('./app/styles/')
gulp.task 'jade',->
  data = {}
  data.images = {}
  data.bg_slider = require './app/json/bg-slider.json'
  data.map = require './app/json/map.json'
#  data.images.bgslider = scandir('./app/images/main-slider','names')
  #  data.images.newSlider = scandir('./app/images/new-slider','names')
  gulp.src('./app/jade/pages/*.jade')
  .pipe(plumber(errorHandler : (error,file) ->
      console.log error.message
      @emit 'end'
    ))
  .pipe(jade(
      pretty : true
      locals : data
    ))
  .pipe gulp.dest('./app/')
  .pipe(connect.reload())
gulp.task 'connect',->
  connect.server
    root : 'app'
    livereload : true
    port : 3000
gulp.task 'watch',->
  gulp.watch './app/styles/**/*.styl',['stylus']
  gulp.watch './app/styles/_sprite.styl',['sprite']
  gulp.watch './app/scripts/**/*.coffee',['coffee']
  gulp.watch './app/jade/**/*.jade',['jade']
  gulp.watch './app/json/**/*.json',['jade']
gulp.task 'default',[
  'sprite'
  'stylus'
  'coffee'
  'jade'
  'watch'
  'connect'
]