describe.only('FormImage', function() {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'FormImage',
      'eventsWithPromises'
    ],
    function (
      phantomShims,
      $,
      FormImage,
      eventsWithPromises
    ) {
      sandbox = sinon.sandbox.create();

      self.$html = $(window.__html__['spec/javascripts/fixtures/FormImage.html']).appendTo('body');

      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
    this.eventsWithPromises.unsubscribeAll();
  });
});
