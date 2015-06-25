define(['jquery', 'DoughBaseComponent', 'eventsWithPromises'], function($, DoughBaseComponent, eventsWithPromises) {
  'use strict';

  var defaultConfig = {
    clientid: '46744299348-7t8tn92mh4pv01vk89llfv0u3q7kup2j.apps.googleusercontent.com',
    onReadyEvent: 'analytics-on-ready'
  };

  function EmbeddedGoogleAnalytics($el, config) {
    EmbeddedGoogleAnalytics.baseConstructor.call(this, $el, config, defaultConfig);
  }

  /**
   * Inherit from base module, for shared methods and interface
   */
  DoughBaseComponent.extend(EmbeddedGoogleAnalytics);

  EmbeddedGoogleAnalytics.componentName = 'EmbeddedGoogleAnalytics';

  EmbeddedGoogleAnalytics.prototype.init = function(initialised) {
    $.getScript('https://apis.google.com/js/platform.js', $.proxy(function() {
      gapi.analytics = {
        q:[],
        ready:function(f){this.q.push(f);}
      };

      gapi.analytics.ready($.proxy(function() {
        eventsWithPromises.publish(this.config.onReadyEvent);
        this.onReady.call(this);
      }, this));

      gapi.load('analytics');
    }, this));

    this._initialisedSuccess(initialised);

    return this;
  };

  EmbeddedGoogleAnalytics.prototype.onReady = function() {
    var path = this.config.path;

    this.createChart({ 'path': path,
                       'metrics': 'ga:pageviews',
                       'chartContainer': 'chart-1-container',
                       'viewContainer': 'view-selector-1-container' });
    this.createChart({ 'path': path,
                       'metrics': 'ga:uniquePageviews',
                       'chartContainer': 'chart-2-container',
                       'viewContainer': 'view-selector-2-container' });
    this.createChart({ 'path': path,
                       'metrics': 'ga:avgTimeOnPage',
                       'chartContainer': 'chart-3-container',
                       'viewContainer': 'view-selector-3-container' });
    this.createChart({ 'path': path,
                       'metrics': 'ga:exitRate',
                       'chartContainer': 'chart-4-container',
                       'viewContainer': 'view-selector-4-container' });
    this.createChart({ 'path': path,
                       'metrics': 'ga:bounceRate',
                       'chartContainer': 'chart-5-container',
                       'viewContainer': 'view-selector-5-container' });

    gapi.analytics.auth.authorize({
      container: 'embed-api-auth-container',
      clientid: this.config.clientid
    });
  };

  EmbeddedGoogleAnalytics.prototype.createChart = function(config) {
    var dataChart = new gapi.analytics.googleCharts.DataChart({
      query: {
        metrics: config.metrics,
        dimensions: 'ga:date',
        filters: 'ga:pagePath=~^' + config.path,
        'start-date': '30daysAgo',
        'end-date': 'yesterday'
      },
      chart: {
        container: config.chartContainer,
        type: 'LINE',
        options: {
          width: '578'
        }
      }
    });

    this._createViewSelector(config, dataChart);
    return dataChart;
  };

  EmbeddedGoogleAnalytics.prototype._createViewSelector = function(config, dataChart) {
    var viewSelector = new gapi.analytics.ViewSelector({
      container: config.viewContainer
    });

    viewSelector.execute();

    viewSelector.on('change', function(ids) {
      dataChart.set({query: {ids: ids}}).execute();
    });

    return viewSelector;
  };

  return EmbeddedGoogleAnalytics;
});
