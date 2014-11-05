module.exports = function(config) {
  config.set({
    basePath: '../../',
    frameworks: ['requirejs','mocha', 'chai', 'sinon'],
    files: [
      'spec/javascripts/fixtures/*.html',
      'spec/javascripts/test-main.js',
      {pattern: 'app/assets/javascripts/comfortable_mexican_sofa/**/*.js', included: false},
      {pattern: 'app/assets/javascripts/comfortable_mexican_sofa/**/**/*.md', included: false},
      {pattern: 'spec/javascripts/tests/*_spec.js', included: false},
      {pattern: 'spec/javascripts/helpers/shims/*.js', included: false},
      {pattern: 'vendor/assets/bower_components/**/*.js', included: false}
    ],
    exclude: [
      'vendor/assets/bower_components/**/test/**/*.js',
      'vendor/assets/bower_components/taggle.js/node_modules/**/*'
    ],
    preprocessors: {
      '**/*.html': ['html2js']
    },
    reporters: ['progress', 'osx'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_ERROR,
    autoWatch: true,
    browsers: ['PhantomJS'],
    captureTimeout: 6000,
    singleRun: false
  });
};
