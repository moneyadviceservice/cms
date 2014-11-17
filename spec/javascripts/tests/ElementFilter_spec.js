describe('Element Filter', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'ElementFilter',
      'phantom-shims'
    ],
    function (
      $,
      ElementFilter
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/ElementFilter.html']);
      self.ElementFilter = ElementFilter;
      self.delay = 100;
      $('body').append(self.$html);
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('Setup the filter trigger link', function () {
    beforeEach(function (done) {
      this.component = new this.ElementFilter(this.$html);
      this.component.init();
      done();
    });
    it('Should bind the trigger link', function() {
      expect(true).to.be.false;
    });
  });

  describe('Filtering', function () {
    beforeEach(function (done) {
      this.component = new this.ElementFilter(this.$html);
      this.component.init();
      done();
    });
    it('Should hide filtered items (remove active class)', function() {
      expect(true).to.be.false;
    });
    it('Should only affect items within its context', function() {
      expect(true).to.be.false;
    });
  });

});
