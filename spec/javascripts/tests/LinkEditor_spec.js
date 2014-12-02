describe('LinkEditor', function () {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'LinkEditor',
      'eventsWithPromises'
    ],
    function (
      phantomShims,
      $,
      LinkEditor,
      eventsWithPromises
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/LinkEditor.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="LinkEditor"]');
      self.LinkEditor = LinkEditor;
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
      this.component = new this.LinkEditor(this.$fixture);
      done();
    });

    it('should cache the tab trigger element references', function() {
      this.component.init();
      expect(this.component.$tabTriggers.length).to.be.at.least(1);
    });
  });

  describe('App Events', function () {
    beforeEach(function (done) {
      this.component = new this.LinkEditor(this.$fixture);
      done();
    });

    it('should call the shown handler method when the dialog:shown event is published', function() {
      var spy = sandbox.spy(this.LinkEditor.prototype, '_handleShown');

      this.component.init();

      this.eventsWithPromises.publish('dialog:shown', {
        emitter: 'add-link'
      });
      expect(spy.called).to.be.true;
    });
  });

  describe('When dialog is opened', function () {
    beforeEach(function (done) {
      this.component = new this.LinkEditor(this.$fixture);
      done();
    });

    it('dialog:shown event\'s emitter ID should be the same as the LinkEditor\'s', function() {
      var spy = sandbox.spy(this.LinkEditor.prototype, '_handleShown');

      this.component.init();
      this.eventsWithPromises.publish('dialog:shown', {
        emitter: 'add-link'
      });
      expect(spy.args[0][0].emitter).to.equal('add-link');
    });

    describe('Editing existing link', function () {
      it('should call the setup function with "existing" param and link', function() {
        var spy = sandbox.spy(this.LinkEditor.prototype, '_setup');

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
        var spy = sandbox.spy(this.LinkEditor.prototype, '_setup');

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
      this.component = new this.LinkEditor(this.$fixture);
      this.component.init();
      done();
    });

    describe('When link is edited', function() {
      it('should activate a tab trigger', function() {
        var spy = sandbox.spy();

        $('[data-dough-linkeditor-tabtrigger]').on('click', spy);
        this.component.changeTab(this.component.$tabTriggers, 'external');
        expect(spy.called).to.be.true;
      });
    });

    describe('When a new link is called', function () {
      it('should activate the "internal" tab trigger', function() {
        var spy = sandbox.spy();

        $('[data-dough-linkeditor-tabtrigger="internal"]').on('click', spy);
        this.component.changeTab(this.component.$tabTriggers, 'internal');
        expect(spy.called).to.be.true;
      });
    });
  });

  describe('Checks link type (link to internal page, external page or a file)', function () {
    beforeEach(function (done) {
      this.component = new this.LinkEditor(this.$fixture);
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

});
