describe('LinkManager', function () {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'LinkManager',
      'eventsWithPromises'
    ],
    function (
      phantomShims,
      $,
      LinkManager,
      eventsWithPromises
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/LinkManager.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="LinkManager"]');
      self.LinkManager = LinkManager;
      self.eventsWithPromises = eventsWithPromises;
      sandbox = sinon.sandbox.create();
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
  });

  describe('Initialisation', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      done();
    });

    it('should cache the insert link, tab trigger, value triggers and tab trigger element references', function() {
      this.component.init();
      expect(this.component.$tabTriggers.length).to.be.at.least(1);
      expect(this.component.$insertLinks.length).to.be.at.least(1);
      expect(this.component.$valueTriggers.length).to.be.at.least(1);
    });
  });

  describe('App Events', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      done();
    });

    it('should call the shown handler method when the dialog:shown event is published', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, '_handleShown');

      this.component.init();

      this.eventsWithPromises.publish('dialog:shown', {
        emitter: 'add-link'
      });
      expect(spy.called).to.be.true;
    });
  });

  describe('When dialog is opened', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      done();
    });

    it('dialog:shown event\'s emitter ID should be the same as the LinkManager\'s', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, '_handleShown');

      this.component.init();
      this.eventsWithPromises.publish('dialog:shown', {
        emitter: 'add-link'
      });
      expect(spy.args[0][0].emitter).to.equal('add-link');
    });

    describe('Editing existing link', function () {
      it('should call the setup function with "existing" param and link', function() {
        var spy = sandbox.spy(this.LinkManager.prototype, '_setup');

        this.component.init();
        this.eventsWithPromises.publish('dialog:shown', {
          emitter: 'add-link',
          link: 'foo'
        });

        expect(spy.calledWith('existing', 'foo')).to.be.true;
      });
    });

    describe('Creating a new link', function () {
      it('should call the setup function with "new" param', function() {
        var spy = sandbox.spy(this.LinkManager.prototype, '_setup');

        this.component.init();
        this.eventsWithPromises.publish('dialog:shown', {
          emitter: 'add-link'
        });

        expect(spy.calledWith('new')).to.be.true;
      });
    });
  });

  describe('UI Events', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    describe('When link is edited', function() {
      it('should activate a tab trigger', function() {
        var spy = sandbox.spy();

        $('[data-dough-linkmanager-tabtrigger]').on('click', spy);
        this.component.changeTab(this.component.$tabTriggers, 'external');
        expect(spy.called).to.be.true;
      });
    });

    describe('When a new link is called', function () {
      it('should activate the "internal" tab trigger', function() {
        var spy = sandbox.spy();

        $('[data-dough-linkmanager-tabtrigger="internal"]').on('click', spy);
        this.component.changeTab(this.component.$tabTriggers, 'internal');
        expect(spy.called).to.be.true;
      });
    });

    describe('When a link is being edited', function () {
      it('should call the update link function when a text input trigger element\'s value is updated', function () {
        var spy = sandbox.spy(this.LinkManager.prototype, 'setLink'),
            fakeEvent = $.Event('keyup'),
            $textInput = this.component.$valueTriggers.filter(':text').first();

        $textInput.val('bar').trigger(fakeEvent);

        expect(spy.calledWith('bar')).to.be.true;
      });

      it('should call the update link function when a radio trigger element\'s option is selected', function () {
        var spy = sandbox.spy(this.LinkManager.prototype, 'setLink');

        this.component.$valueTriggers
          .filter(':radio')
          .first()
          .val('foo')
          .click();

        expect(spy.calledWith('foo')).to.be.true;
      });

      it('should execute the publish the link when an insertlink button is created', function() {
        var spy = sandbox.spy();

        this.component.$valueTriggers
          .filter(':radio')
          .first()
          .val('foo')
          .click();

        this.eventsWithPromises.subscribe('linkmanager:link-published', spy);
        this.component.$insertLinks.first().click();
        expect(spy.called).to.be.true;
      });
    });
  });

  describe('Checks link type (link to internal page, external page or a file)', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should return an internal link type' , function() {
      expect(this.component._getLinkType('/en/articles/foo')).to.equal('internal');
    });

    it('should return an external link type', function() {
      expect(this.component._getLinkType('http://www.foo.com')).to.equal('external');
    });

    it('should return an external file type', function() {
      expect(this.component._getLinkType('http://www.foo.com/file.pdf')).to.equal('external');
    });

    it('should return an internal file type' , function() {
      expect(this.component._getLinkType('/file.pdf')).to.equal('internal');
    });

    it('should return false if no link type is found' , function() {
      expect(this.component._getLinkType('foo')).to.be.false;
    });
  });

  describe('Updating the link value inputs', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    afterEach(function () {
      this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="internal"]').val('/foo');
      this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="external"]').val('http://foo.com');
      this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="file"]').val('foo.pdf');
    });

    it('should set the internal link value inputs with the passed link', function () {
      this.component.setInputs('internal', '/bar');
      expect(this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="internal"]').first().val()).to.equal('/bar');
    });

    it('should set the external link value inputs with the passed link', function () {
      this.component.setInputs('external', 'http://bar.com');
      expect(this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="external"]').first().val()).to.equal('http://bar.com');
    });

    it('should set the file link value inputs with the passed link', function () {
      this.component.setInputs('file', 'bar.pdf');
      expect(this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="file"]').first().val()).to.equal('bar.pdf');
    });
  });

  describe('Publish link', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should publish the link variable and emitter ID via the events bus', function() {
      var spy = sandbox.spy(),
          link = 'http://www.foo.com';

      this.eventsWithPromises.subscribe('linkmanager:link-published', spy);

      this.component.setLink(link);
      this.component.publishLink(link);

      expect(spy.args[0][0].link).to.equal(link);
      expect(spy.args[0][0].emitter).to.equal('add-link');
    });
  });

  describe('Track the currently selected link', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the link variable', function() {
      var link = 'http://foo.com';

      this.component.setLink(link);
      expect(this.component.link).to.eq(link);
    });
  });

});
