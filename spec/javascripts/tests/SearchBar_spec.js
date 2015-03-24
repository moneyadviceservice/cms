describe('SearchBar', function() {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'eventsWithPromises',
      'SearchBar'
    ],
    function(
      phantomShims,
      $,
      eventsWithPromises,
      SearchBar
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/SearchBar.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="SearchBar"]');
      self.SearchBar = SearchBar;
      self.eventsWithPromises = eventsWithPromises;
      sandbox = sinon.sandbox.create();
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
    this.eventsWithPromises.unsubscribeAll();
  });

  describe('when a toggled event is received from Collapsable', function () {
    beforeEach(function(done) {
      this.component = new this.SearchBar(this.$fixture);
      done();
    });

    it('should shift focus to the search input', function() {
      this.component.init();

      this.eventsWithPromises.publish('toggler:toggled', {
        emitter: this.component.collapsable,
        visible: true
      });

      expect(document.activeElement).to.eq(this.component.$searchBarInput[0]);
    });
  });
});
