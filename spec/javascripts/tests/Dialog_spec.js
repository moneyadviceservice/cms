describe('Dialog', function() {
  'use strict';

  var sandbox;

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
      sandbox = sinon.sandbox.create();

      self.$html = $(window.__html__['spec/javascripts/fixtures/Dialog.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="Dialog"]');
      self.Dialog = Dialog;
      self.showSpy = sandbox.spy(self.Dialog.prototype, 'show');
      self.closeSpy = sandbox.spy(self.Dialog.prototype, 'close');
      self.handleCancelSpy = sandbox.spy(self.Dialog.prototype, '_handleCancel');
      self.eventsWithPromises = eventsWithPromises;

      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
    $('[data-dough-dialog]').remove();
    this.eventsWithPromises.unsubscribeAll();
  });

  describe('Initialisation', function() {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      done();
    });

    it('should create the dialog element, child elements and append it to the body', function() {
      var $body = $('body');
      this.component.init();
      expect($body.find(this.component.config.selectors.dialog).length).to.equal(1);
      expect(this.component.$dialog.find(this.component.config.selectors.container).length).to.equal(1);
      expect(this.component.$dialogContainer.find(this.component.config.selectors.containerInner).length).to.equal(1);
      expect(this.component.$dialogContainerInner.find(this.component.config.selectors.content).length).to.equal(1);
      expect(this.component.$dialogContent.find(this.component.config.selectors.contentInner).length).to.equal(1);
      expect(this.component.$dialogContentInner.find(this.component.config.selectors.close).length).to.equal(1);
    });

    it('should use the context to find the target if a trigger attribute is not provided', function() {
      var targetAttr = 'data-dough-dialog-target';
      this.$fixture.removeAttr('data-dough-dialog-trigger');
      this.$fixture.attr('data-dough-dialog-context', 'foo');
      this.$fixture.parent('div').find('[' + targetAttr + ']').attr(targetAttr, 'foo');
      this.component.init();
      expect(this.component.$target.length).to.be.at.least(1);
    });

    it('should save the dialog component context to a variable', function() {
      var context = this.$fixture.attr('data-dough-dialog-context');
      this.$fixture.attr('data-dough-dialog-context', 'bar');
      this.component.init();
      expect(this.component.context).to.equal('bar');
      this.$fixture.attr('data-dough-dialog-context', context);
    });
  });

  describe('Events', function() {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should show the dialog when clicking the trigger ', function() {
      this.component.$trigger.click();
      expect(this.showSpy.called).to.be.true;
    });

    it('should hide the dialog when clicking the close button ', function() {
      this.component.$trigger.click();
      this.component.$dialog.find(this.component.config.selectors.close).click();
      expect(this.closeSpy.called).to.be.true;
    });

    it('should broadcast the dialog context event when shown', function() {
      var spy = sandbox.spy();
      this.eventsWithPromises.subscribe('dialog:shown', spy);
      this.component.show();
      expect(spy.args[0][0].emitter).to.equal('foo');
    });

    it('should show the dialog when the dialog:show event is published', function() {
      this.eventsWithPromises.publish('dialog:show', { emitter: 'foo'});
      expect(this.showSpy.called).to.be.true;
    });

    it('should close the dialog if a dialog:close event with matching emitter parameter is received', function() {
      this.component._handleClose();
      this.eventsWithPromises.publish('dialog:close', {
        emitter: 'foo'
      });
      expect(this.closeSpy.called).to.be.true;
    });
  });

  describe('Show dialog', function() {
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

    it('should trigger a shown event', function() {
      var spy = sandbox.spy();
      this.eventsWithPromises.subscribe('dialog:shown', spy);
      this.component.show();
      expect(spy.args[0][0].emitter).to.equal('foo');
    });

    it('should add the active class to the dialog element', function() {
      this.component.show();
      expect(this.component.$dialog.hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });
  });

  describe('Show dialog (showModal)', function() {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should show the dialog using the Dialog showModal() method', function() {
      var spy;
      this.component.dialog.showModal = function() {};
      spy = sandbox.spy(this.component.dialog, 'showModal');
      this.component.show(true);
      expect(this.showSpy.calledWith(true)).to.be.true;
      expect(spy.called).to.be.true;
    });

    it('should trigger a shown event and return modal=true in callback arguments', function() {
      var spy = sandbox.spy();
      this.eventsWithPromises.subscribe('dialog:shown', spy);
      this.component.show(true);
      expect(spy.args[0][0].modal).to.be.true;
    });

    it('should toggle between inactive/active class on the dialog element', function() {
      this.component.show();
      expect(this.component.$dialog.hasClass(this.component.config.selectors.inactiveClass)).to.be.false;
      expect(this.component.$dialog.hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });

    it('should toggle between inactive/active class on the dialog target', function() {
      this.component.show();
      expect(this.component.$target.hasClass(this.component.config.selectors.inactiveClass)).to.be.false;
      expect(this.component.$target.hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });

    it('should add the dialog open class to the body', function() {
      expect($('body').hasClass(this.component.config.selectors.dialogOpenBodyClass)).to.be.true;
    });
  });

  describe('Close dialog', function() {
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

    it('should trigger a closed event', function() {
      var spy = sandbox.spy();
      this.eventsWithPromises.subscribe('dialog:closed', spy);
      this.component.show();
      this.component.close();
      expect(spy.called).to.be.true;
    });

    it('should toggle between active/inactive class on the dialog element', function() {
      this.component.show();
      this.component.close();
      expect(this.component.$dialog.hasClass(this.component.config.selectors.inactiveClass)).to.be.true;
      expect(this.component.$dialog.hasClass(this.component.config.selectors.activeClass)).to.be.false;
    });

    it('should toggle between active/inactive class on the dialog target', function() {
      this.component.show();
      this.component.close();
      expect(this.component.$target.hasClass(this.component.config.selectors.inactiveClass)).to.be.true;
      expect(this.component.$target.hasClass(this.component.config.selectors.activeClass)).to.be.false;
    });

    it('should remove the dialog open class from the body', function() {
      expect($('body').hasClass(this.component.config.selectors.dialogOpenBodyClass)).to.be.false;
    });
  });

  describe('Close dialog (cancelled)', function() {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should trigger a cancelled event', function() {
      var spy = sandbox.spy();
      this.eventsWithPromises.subscribe('dialog:cancelled', spy);
      this.component.show();
      this.component.close(true);
      expect(spy.called).to.be.true;
    });
  });

  describe('Set Content', function() {
    beforeEach(function (done) {
      this.component = new this.Dialog(this.$fixture);
      this.component.init();
      done();
    });

    it('should append the dialog target to the dialog content', function() {
      this.component.show();
      expect(this.component.$dialogContent.find(this.component.config.selectors.target).is(this.component.$target)).to.be.true;
    });

    it('should trigger a ready event', function() {
      var spy = sandbox.spy();
      this.eventsWithPromises.subscribe('dialog:ready', spy);
      this.component.show();
      expect(spy.called).to.be.true;
    });

  });
});

