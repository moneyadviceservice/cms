describe('ImageManager', function () {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'ImageManager',
      'eventsWithPromises'
    ],
    function (
      phantomShims,
      $,
      ImageManager,
      eventsWithPromises
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/ImageManager.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="ImageManager"]');
      self.ImageManager = ImageManager;
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

  describe.skip('Initialisation', function () {
    beforeEach(function (done) {
      this.component = new this.ImageManager(this.$fixture);
      done();
    });

    it('should', function() {
    });
  });

});
