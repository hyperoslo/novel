var gulp = require('gulp');
var watch = require ('gulp-watch');
var sass = require('gulp-ruby-sass');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');
var gutil = require('gulp-util');
var bower = require('gulp-bower');
var mainBowerFiles = require('main-bower-files')
var cleanCSS = require('gulp-clean-css');

var paths = {
  root: './',
   scss: './src/scss',
  js: './src/js',
   vendor: './bower_components' ,
  dest: '../../Public'
}

// Helpers

gulp.task('bower', function() { 
  return bower()
     .pipe(gulp.dest(paths.vendor)) 
});

// Vendor

gulp.task('vendor-fonts', function() { 
  var filter = [
    '**/*.otf',
    '**/*.eot',
    '**/*.ttf',
    '**/*.woff',
    '**/*.woff2',
    '**/*.svg'
  ]

  return gulp.src(mainBowerFiles({ filter: filter, paths: paths.root }))
  	.pipe(gulp.dest(paths.dest + "/fonts")); 
});

gulp.task('vendor-css', function() { 
  var filter = [
    '**/*.css',
    '!**/*.min.css'
  ]

  return gulp.src(mainBowerFiles({ filter: filter, paths: paths.root }))
    .pipe(concat('vendor.css'))
    .pipe(cleanCSS())
		.pipe(gulp.dest(paths.dest + "/css"));
});

gulp.task('vendor-js', function() {
  var filter = [
    '**/*.js',
    '!**/*.min.js'
  ]

  return gulp.src(mainBowerFiles({ filter: filter, paths: paths.root }))
    .pipe(concat('vendor.js'))
    .pipe(uglify())
    .pipe(gulp.dest(paths.dest + '/js'));
});

// App

gulp.task('app-css', function() { 
  return sass(paths.scss + '/main.scss', {
     style: 'compressed',
     loadPath: [
       paths.scss,
       paths.vendor
     ]
   }) 
  .on('error', sass.logError)
   .pipe(gulp.dest(paths.dest + '/css')); 
});

gulp.task('app-js', function() {
  return gulp.src(paths.js + '/**/*.js')
    .pipe(concat('main.js'))
    .pipe(gutil.env.type === 'production' ? uglify() : gutil.noop())
    .pipe(gulp.dest(paths.dest + '/js'));
});

// Tasks

 gulp.task('watch-css', function() {
   gulp.watch(paths.scss + '/**/*.scss', ['app-css']); 
});

gulp.task('watch-js', function() {
   gulp.watch(paths.js + '/**/*.js', ['app-js']); 
});

gulp.task('watch', [
  'watch-css',
  'watch-js'
]);

  gulp.task('default', [
  'bower',
  'vendor-fonts',
  'vendor-css',
  'vendor-js',
  'app-css',
  'app-js'
]);
