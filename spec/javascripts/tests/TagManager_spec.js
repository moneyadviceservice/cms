describe.only('Element Filter', function () {
  'use strict';

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
      self.$html = $(window.__html__['spec/javascripts/fixtures/TagManager.html']).appendTo('body');
      self.$fixture = $('body').find('[data-dough-component="TagManager"]');
      self.TagManager = TagManager;
      self.eventsWithPromises = eventsWithPromises;
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('Initialisation', function () {
    beforeEach(function (done) {
      this.component = new this.TagManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should cache tag usage placeholders, delete target and close buttons', function() {
      expect(this.component.$deleteTarget.length).to.eq(1);
      expect(this.component.$tagUsagePlaceholders.length).to.be.at.least(1);
      expect(this.component.$confirmDeleteButtons.length).to.be.at.least(1);
      expect(this.component.$closeButtons.length).to.be.at.least(1);
    });
  });

  describe('On dialog:shown', function () {
    beforeEach(function (done) {
      this.component = new this.TagManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the tag usage placeholder content', function () {
      this.eventsWithPromises.publish('dialog:shown', {
        emitter: 'delete-tag'
      });

      expect(this.component.$tagUsagePlaceholders.first().text()).to.eq('45');
    });
  });

  describe('When the delete tag is clicked', function () {
    beforeEach(function (done) {
      this.component = new this.TagManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should publish a tagmanager:delete event', function() {
      var spy = sinon.spy();

      this.eventsWithPromises.subscribe('tagmanager:delete', spy);
      this.component.$confirmDeleteButtons.first().click();

      expect(spy.called).to.be.true;
    });

    it('should close the dialog', function() {
      var spy = sinon.spy();

      this.eventsWithPromises.subscribe('dialog:close', spy);
      this.component.$confirmDeleteButtons.first().click();

      expect(spy.called).to.be.true;
    });
  });
});
