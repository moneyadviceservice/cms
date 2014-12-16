describe.only('TagManager', function () {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'TagManager',
      'eventsWithPromises'
    ],
    function (
      $,
      TagManager,
      eventsWithPromises
    ) {
      sandbox = sinon.sandbox.create();

      self.$html = $(window.__html__['spec/javascripts/fixtures/TagManager.html']).appendTo('body');
      self.$fixture = $('body').find('[data-dough-component="TagManager"]');
      self.TagManager = TagManager;
      self.eventsWithPromises = eventsWithPromises;
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
    sandbox.restore();
    this.eventsWithPromises.unsubscribeAll();
  });

  describe('Initialisation', function () {
    beforeEach(function (done) {
      this.component = new this.TagManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should cache tag usage placeholders, delete target and close buttons', function() {
      expect(this.component.$trigger.length).to.eq(1);
      expect(this.component.$tagUsagePlaceholders.length).to.be.at.least(1);
      expect(this.component.$confirmDeleteButtons.length).to.be.at.least(1);
      expect(this.component.$closeButtons.length).to.be.at.least(1);
    });
  });

  describe('When a tag\'s delete button is clicked', function () {
    beforeEach(function (done) {
      this.component = new this.TagManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the tag usage placeholder content', function () {
      this.component.$trigger.click();
      expect(this.component.$tagUsagePlaceholders.first().text()).to.eq('45');
    });
  });

  describe('When the delete tag button is clicked', function () {
    beforeEach(function (done) {
      this.component = new this.TagManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should publish a tagmanager:delete event', function() {
      var spy = sandbox.spy();

      this.eventsWithPromises.subscribe('tagmanager:delete', spy);
      this.component.show();

      this.component.$confirmDeleteButtons.first().click();

      expect(spy.called).to.be.true;
    });

    it('should close the dialog', function() {
      var spy = sandbox.spy();

      this.component.show();
      this.eventsWithPromises.subscribe('dialog:close', spy);
      this.component.$confirmDeleteButtons.first().click();

      expect(spy.called).to.be.true;
    });
  });
});
