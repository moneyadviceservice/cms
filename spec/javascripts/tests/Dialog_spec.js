describe('Dialog', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'Dialog',
      'eventsWithPromises'
    ],
    function (
      $,
      Dialog,
      eventsWithPromises
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/Dialog.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="Dialog"]');
      self.Dialog = Dialog;
      self.eventsWithPromises = eventsWithPromises;
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('Initialisation', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should create the modal elements', function() {
      var $body = $('body');
      expect($body.find('[data-dialog-target]').length).to.equal(1);
    });

    it('should listen for events', function() {
      // dialog:show
      expect(false).to.be.true;
      // dialog:hide
      expect(false).to.be.true;
      // dialog:set-content
      expect(false).to.be.true;
    });

    it('should trigger initialised event', function() {
      // dialog:initialised
      expect(false).to.be.true;
    });

  });

  describe('Set Content', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should update the content of the dialog content area', function () {

    });

    it('should call the ready method', function() {
      // dialog:initialised
      expect(false).to.be.true;
    });
  });

  describe('Ready (onReady)', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      this.showSpy = sinon.spy(this.Dialog.prototype, 'show');
      done();
    });

    afterEach(function () {
      this.showSpy.restore();
    });

    it('should trigger a ready event', function () {
      // dialog:ready
      expect(false).to.be.true;
    });

    it('should show the dialog', function() {
      expect(this.showSpy.called).to.be.true;
    });
  });
});

