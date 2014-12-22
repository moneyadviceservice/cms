describe('LinkManager', function() {
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
    function(
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
    this.eventsWithPromises.unsubscribeAll();
  });

  describe('App Events', function() {
    beforeEach(function(done) {
      this.component = new this.LinkManager(this.$fixture, {
        tabIds: {
          'page': 'page',
          'file': 'file',
          'external': 'external'
        }
      });
      done();
    });

    it('should call _handleShown when the cmseditor:insert-published event is published', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, '_handleShown');

      this.component.init();
      this.eventsWithPromises.publish('cmseditor:insert-published', {
        emitter: 'add-link'
      });
      expect(spy.called).to.be.true;
    });
  });

  describe('When dialog is opened', function() {
    beforeEach(function(done) {
      this.component = new this.LinkManager(this.$fixture, {
        tabIds: {
          'page': 'page',
          'file': 'file',
          'external': 'external'
        }
      });
      done();
    });

    it('cmseditor:insert-published event\'s emitter ID should be the same as the InsertManager\'s', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, '_handleShown');

      this.component.init();
      this.eventsWithPromises.publish('cmseditor:insert-published', {
        emitter: 'add-link'
      });
      expect(spy.args[0][0].emitter).to.equal('add-link');
    });

    describe('Editing existing value', function() {
      it('should call the setup function with "existing" param and value', function() {
        var spy = sandbox.spy(this.LinkManager.prototype, '_setup');

        this.component.init();
        this.eventsWithPromises.publish('cmseditor:insert-published', {
          emitter: 'add-link',
          val: 'foo'
        });
        expect(spy.calledWith('existing', 'foo')).to.be.true;
      });
    });

    describe('Creating a new link', function() {
      it('should call the setup function with "new" param', function() {
        var spy = sandbox.spy(this.LinkManager.prototype, '_setup');

        this.component.init();
        this.eventsWithPromises.publish('cmseditor:insert-published', {
          emitter: 'add-link'
        });

        expect(spy.calledWith('new')).to.be.true;
      });
    });
  });

});
