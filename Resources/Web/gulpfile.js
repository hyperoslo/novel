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
  src: './src',
  admin: {
    scss: './src/admin/scss',
    js: './src/admin/js',
    images: './src/admin/images'
  },
  demo: {
    scss: './src/demo/scss',
    js: './src/demo/js',
  },
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

// Admin

gulp.task('admin-css', function() { 
  return sass(paths.admin.scss + '/admin.scss', {
     style: 'compressed',
     loadPath: [
       paths.admin.scss,
       paths.vendor
     ]
   }) 
  .on('error', sass.logError)
   .pipe(gulp.dest(paths.dest + '/css')); 
});

gulp.task('admin-js', function() {
  return gulp.src(paths.admin.js + '/**/*.js')
    .pipe(concat('admin.js'))
    .pipe(gutil.env.type === 'production' ? uglify() : gutil.noop())
    .pipe(gulp.dest(paths.dest + '/js'));
});

gulp.task('admin-images', function() {
   gulp.src(paths.admin.images + '/**/*.{png,jpg,svg}')
   .pipe(gulp.dest(paths.dest + '/images'));
});

// Demo

gulp.task('demo-css', function() { 
  return sass(paths.demo.scss + '/demo.scss', {
     style: 'compressed',
     loadPath: [
       paths.demo.scss,
       paths.vendor
     ]
   }) 
  .on('error', sass.logError)
   .pipe(gulp.dest(paths.dest + '/css')); 
});

gulp.task('demo-js', function() {
  return gulp.src(paths.demo.js + '/**/*.js')
    .pipe(concat('demo.js'))
    .pipe(gutil.env.type === 'production' ? uglify() : gutil.noop())
    .pipe(gulp.dest(paths.dest + '/js'));
});

// Tasks

 gulp.task('watch-css', function() {
   gulp.watch(paths.src + '/**/*.scss', ['admin-css', 'demo-css']); 
});

gulp.task('watch-js', function() {
   gulp.watch(paths.src + '/**/*.js', ['admin-js', 'demo-js']); 
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
  'admin-css',
  'admin-js',
  'admin-images',
  'demo-css',
  'demo-js'
]);
