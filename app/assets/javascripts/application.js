//= require require_config

require(['componentLoader', 'jquery'], function(componentLoader, $) {
  'use strict';

  componentLoader.init($('body'));

  $('.analytics-button').on('click', function() {
    $('.analytics-charts').toggle(function() {
      $('html, body').animate({ scrollTop: 0 }, 500);
    });
  });
});
