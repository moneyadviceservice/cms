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

  describe('Slugify function', function() {
    beforeEach(function(done) {
      this.component = new this.LinkManager(this.$fixture, {
        tabIds: {
          'page': 'page',
          'file': 'file',
          'external': 'external',
          'anchor': 'anchor'
        }
      });
      done();
    });

    it('should return a URL-friendly version of the given string', function() {
      var str = 'foo%^@£$%!   123--123   ?',
          generatedSlug = this.component._slugify(str);

      expect(generatedSlug).to.equal('foo-123--123-');
    });
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
          'external': 'external',
          'anchor': 'anchor'
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

    describe('Populating anchor links', function() {
      beforeEach(function(done) {
        this.component.init();        
        done();
      });

      it('should call the _populateAnchors function', function() {
        var spy = sandbox.spy(this.LinkManager.prototype, '_populateAnchors');
        this.component._setup();
        expect(spy.called).to.be.true;
      });

      it('should render additional select options based upon headings in the editable area', function() {
        this.component._setup();
        expect($(this.component.config.selectors.anchors).children('option').size()).to.equal(4);
      });

      it('should generate valid option values for headings without IDs', function() {
        this.component._setup();
        $(this.component.config.selectors.anchors).children().eq(3).prop('selected', true);
        expect($(this.component.config.selectors.anchors)).to.have.value('#h-c');
      });
    });
  });
});
