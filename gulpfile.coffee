path = require('path')
gulp = require('gulp')
gutil = require 'gulp-util'

runSequence = require('run-sequence')

clean = require('gulp-rimraf')
coffee = require ('gulp-coffee')
mocha = require('gulp-mocha')

task = gulp.task.bind(gulp)
watch = gulp.watch.bind(gulp)
src = gulp.src.bind(gulp)
dest = gulp.dest.bind(gulp)

srcStream = src('').constructor
srcStream::to = (dst) -> @pipe(dest(dst))
srcStream::pipelog = (obj, log=gutil.log) -> @pipe(obj).on('error', log)

task 'wait', -> gulp.src('src/server/app.coffee').pipe(wait(300))

task 'clean', -> src( ['dist'], {read:false}).pipe(clean())

task 'copy', -> src(['src/**/*.js', 'src/**/*.json', 'src/**/*.html'], {cache:'copy'}).to( 'dist')

task 'coffee', -> src('src/**/*.coffee').pipelog(coffee({bare: true})).pipe(dest('dist'))

onErrorContinue = (err) -> console.log(err.stack); @emit 'end'
task 'mocha', ->  src('app/test/mocha-server/**/test*.js').pipe(mocha({reporter: 'spec'})).on("error", onErrorContinue)
task 'test', (callback) -> runSequence('make', 'mocha', callback)

task 'watch',  ->
  gulp.watch ['src/**/*.css', 'src/**/*.html', 'src/**/*.js','src/**/*json'], ['copy']
  gulp.watch 'src/**/*.coffee', ['coffee']

task 'build', (callback) -> runSequence 'clean', ['copy', 'coffee'], callback

task 'bw', (callback) -> runSequence 'build', ['watch'], callback

task 'b', ['build']
task 'w', ['watch']

task 'default', ['build']

