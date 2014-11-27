describe('LinkInserter', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'LinkInserter',
      'eventsWithPromises'
    ],
    function (
      phantomShims,
      $,
      LinkInserter,
      eventsWithPromises
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/LinkInserter.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="LinkInserter"]');
      self.LinkInserter = LinkInserter;
      self.eventsWithPromises = eventsWithPromises;
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('Initialisation', function () {
    beforeEach(function (done) {
      this.component = new this.LinkInserter(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the target ', function () {
      expect(false).to.be.true;
    });

  });

  describe('Update Link to Insert', function () {
    beforeEach(function (done) {
      this.component = new this.LinkInserter(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the updated link', function() {
      var link = 'http://foo.com';
      this.component.updateLink(link);
      expect(this.component.link).to.eq(link);
    });
  });

  describe('Insert Link', function () {
    beforeEach(function (done) {
      this.component = new this.LinkInserter(this.$fixture);
      this.component.init();
      done();
    });

    it('should post the link via an event', function() {
      var spy = sinon.spy(),
          link = 'http://foo.com';
      this.component.updateLink(link);
      this.component.broadcastLink(link);
      this.eventsWithPromises.subscribe('link-inserter:link-updated', spy);
      expect(spy.calledWith(link)).to.be.true;
    });
  });

});
