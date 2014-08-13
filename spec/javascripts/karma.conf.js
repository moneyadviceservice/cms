module.exports = function(config) {
  config.set({
    basePath: '../../',
    frameworks: ['requirejs','mocha', 'chai', 'sinon'],
    files: [
      'spec/javascripts/fixtures/*.html',
      'spec/javascripts/test-main.js',
      {pattern: 'spec/javascripts/tests/*_spec.js', included: false},
      {pattern: 'vendor/assets/bower_components/**/*.js', included: false}
    ],
    exclude: [
      'vendor/assets/bower_components/**/**/*.js'
    ],
    preprocessors: {
      '**/*.html': ['html2js']
    },
    reporters: ['progress', 'coverage'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_ERROR,
    autoWatch: true,
    browsers: ['PhantomJS'],
    captureTimeout: 6000,
    singleRun: false
  });
};
