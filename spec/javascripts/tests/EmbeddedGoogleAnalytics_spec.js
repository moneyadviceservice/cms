describe('EmbeddedGoogleAnalytics', function() {
  'use strict';

  var sandbox,
      component;

  before(function(done) {
    var self = this;
    this.timeout(5000);

    require(['jquery', 'EmbeddedGoogleAnalytics', 'eventsWithPromises'], function($, EmbeddedGoogleAnalytics, eventsWithPromises) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/EmbeddedGoogleAnalytics.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="EmbeddedGoogleAnalytics"]');
      self.EmbeddedGoogleAnalytics = EmbeddedGoogleAnalytics;
      sandbox = sinon.sandbox.create();

      component = new EmbeddedGoogleAnalytics(self.$fixture, self.$fixture.data('doughEmbeddedGoogleAnalyticsConfig'));
      eventsWithPromises.subscribe(component.config.onReadyEvent, function() {
        // When a user isn't able to authorize (the tests never will), this error
        // event is thrown. It then bubbles up to Mocha,
        // which throws an error "at some point later" (when
        // ths response comes back). That error then makes whatever
        // test is running at the time fail.
        gapi.analytics.auth.on('error', function(response) {});

        done();
      });

      component.init();
      component.$el.show();
    });
  });

  after(function() {
    this.$html.remove();
    sandbox.restore();
  });

  describe('after initialised', function() {
    it('renders auth link', function() {
      expect(component.$el.find('#embed-api-auth-container:contains("Access Google Analytics")')).to.not.be.empty;
    });

    it('uses path from config', function() {
      expect(component.config.path).to.equal('/en/articles/foo');
    });

    it('create a DataChart', function() {
      var config = { 'chartContainer': 'some-chart-container',
                     'viewContainer': 'some-view-container',
                     'metrics': 'some-metrics',
                     'path': '/some/path' };

      var dataChart = component.createChart(config);

      expect(dataChart.qa.chart.container).equal('some-chart-container');
      expect(dataChart.qa.query.metrics).equal('some-metrics');
      expect(dataChart.qa.query.filters).equal('ga:pagePath=~^/some/path');
    });

    it('create a ViewSelector', function() {
      var config = { 'chartContainer': 'some-chart-container',
                     'viewContainer': 'some-view-container',
                     'metrics': 'some-metrics',
                     'path': '/some/path' },
          dataChart = new gapi.analytics.googleCharts.DataChart({}),
          viewSelector = component._createViewSelector(config, dataChart);

      expect(viewSelector.qa.container).equal('some-view-container');
    });

    it('create a ViewSelector change binding', function() {
      var config = { 'chartContainer': 'some-chart-container',
                     'viewContainer': 'some-view-container',
                     'metrics': 'some-metrics',
                     'path': '/some/path' },
          dataChart = new gapi.analytics.googleCharts.DataChart({}),
          viewSelector = component._createViewSelector(config, dataChart);

      expect(viewSelector.G.B).to.include('change');
    });

    it('executes the viewSelector after creation', function() {
        var config = { 'chartContainer': 'some-chart-container',
                           'viewContainer': 'some-view-container',
                       'metrics': 'some-metrics',
                       'path': '/some/path' },
            dataChart = new gapi.analytics.googleCharts.DataChart({}),
            viewSelector = component._createViewSelector(config, dataChart),
            spy = sinon.spy(viewSelector, 'execute');

     expect(spy).to.have.been.called;
    });
  });
});
