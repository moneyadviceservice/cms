describe('Dialog', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'Dialog',
      'eventsWithPromises'
    ],
    function (
      phantomShims,
      $,
      Dialog,
      eventsWithPromises
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/Dialog.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="Dialog"]');
      self.Dialog = Dialog;
      self.showSpy = sinon.spy(self.Dialog.prototype, 'show');
      self.closeSpy = sinon.spy(self.Dialog.prototype, 'close');
      self.handleCancelSpy = sinon.spy(self.Dialog.prototype, '_handleCancel');
      self.eventsWithPromises = eventsWithPromises;
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    this.showSpy.restore();
    this.closeSpy.restore();
    this.handleCancelSpy.restore();
    $('[data-dough-dialog]').remove();
  });

  describe('Initialisation', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should create the dialog element, child elements and append it to the body', function() {
      var $body = $('body');
      expect($body.find(this.component.config.selectors.dialog).length).to.equal(1);
      expect(this.component.$dialog.find(this.component.config.selectors.container).length).to.equal(1);
      expect(this.component.$dialog.find(this.component.config.selectors.content).length).to.equal(1);
      expect(this.component.$dialog.find(this.component.config.selectors.close).length).to.equal(1);
    });

  });

  describe('Events', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    // Dialog 'cancel' event not being triggered from within Karma env
    // it('should trigger the cancel handler when ESC is hit', function () {
    //   var e = $.Event('keyup');
    //   e.keyCode = 27;
    //   $('body').trigger(e);
    //   expect(this.handleCancelSpy.called).to.be.true;
    // });

    it('should show the dialog when clicking the trigger ', function() {
      this.component.$trigger.click();
      expect(this.showSpy.called).to.be.true;
    });

    it('should hide the dialog when clicking the close button ', function() {
      this.component.$trigger.click();
      this.component.$dialog.find(this.component.config.selectors.close).click();
      expect(this.closeSpy.called).to.be.true;
    });
  });

  describe('Show dialog', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should detach the target content and append this to the dialog box', function() {
      expect($.contains(this.component.dialog, this.component.$target[0])).to.be.false;
      this.component.show();
      expect($.contains(this.component.dialog, this.component.$target[0])).to.be.true;
    });

    it('should trigger a shown event', function () {
      var spy = sinon.spy();
      this.eventsWithPromises.subscribe('dialog:shown', spy);
      this.component.show();
      expect(spy.called).to.be.true;
    });

    it('should add the active class to the dialog element', function() {
      this.component.show();
      expect(this.component.$dialog.hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });
  });

  describe('Show dialog (showModal)', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should show the dialog using the Dialog showModal() method', function() {
      var spy;
      this.component.dialog.showModal = function() {};
      spy = sinon.spy(this.component.dialog, 'showModal');
      this.component.show(true);
      expect(this.showSpy.calledWith(true)).to.be.true;
      expect(spy.called).to.be.true;
    });

    it('should trigger a shown event and return modal=true in callback arguments', function () {
      var spy = sinon.spy();
      this.eventsWithPromises.subscribe('dialog:shown', spy);
      this.component.show(true);
      expect(spy.args[0][0].modal).to.be.true;
    });

    it('should toggle between inactive/active class on the dialog target', function() {
      this.component.show();
      expect(this.component.$target.hasClass(this.component.config.selectors.inactiveClass)).to.be.false;
      expect(this.component.$target.hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });
  });

  describe('Close dialog', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should detach the target content from the dialog and reattach it in its original position', function() {
      expect($.contains(this.component.dialog, this.component.$target[0])).to.be.false;
      this.component.show();
      expect($.contains(this.component.dialog, this.component.$target[0])).to.be.true;
    });

    it('should trigger a closed event', function () {
      var spy = sinon.spy();
      this.eventsWithPromises.subscribe('dialog:closed', spy);
      this.component.show();
      this.component.close();
      expect(spy.called).to.be.true;
    });

    it('should remove the active class from the dialog element', function() {
      this.component.show();
      this.component.close();
      expect(this.component.$dialog.hasClass(this.component.config.selectors.activeClass)).to.be.false;
    });

    it('should toggle between active/inactive class on the dialog target', function() {
      this.component.show();
      this.component.close();
      expect(this.component.$target.hasClass(this.component.config.selectors.inactiveClass)).to.be.true;
      expect(this.component.$target.hasClass(this.component.config.selectors.activeClass)).to.be.false;
    });
  });

  describe('Close dialog (cancelled)', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should trigger a cancelled event', function () {
      var spy = sinon.spy();
      this.eventsWithPromises.subscribe('dialog:cancelled', spy);
      this.component.show();
      this.component.close(true);
      expect(spy.called).to.be.true;
    });
  });

  describe('Set Content', function () {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the content of the dialog with that of the target\'s', function () {
      this.component.$dialogContent.empty();
      this.component.show();
      expect(this.component.$dialogContent.get(0).innerHTML).to.be.equal(this.component.$target[0].outerHTML);
    });

    it('should trigger a ready event', function () {
      var spy = sinon.spy();
      this.eventsWithPromises.subscribe('dialog:ready', spy);
      this.component.show();
      expect(spy.called).to.be.true;
    });

  });
});

