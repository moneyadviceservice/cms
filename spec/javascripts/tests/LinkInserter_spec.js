describe('LinkInserter', function () {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'LinkInserter',
      'eventsWithPromises'
    ],
    function (
      phantomShims,
      $,
      LinkInserter,
      eventsWithPromises
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/LinkInserter.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="LinkInserter"]');
      self.LinkInserter = LinkInserter;
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
      this.component = new this.LinkInserter(this.$fixture);
      done();
    });

    it('should cache the insert link, value triggers and tab trigger element references', function() {
      this.component.init();
      expect(this.component.$insertLinks.length).to.be.at.least(1);
      expect(this.component.$valueTriggers.length).to.be.at.least(1);
    });
  });


  describe('UI Events', function () {
    beforeEach(function (done) {
      this.component = new this.LinkInserter(this.$fixture);
      this.component.init();
      done();
    });

    it('should call the update link function when a text input trigger element\'s value is updated', function () {
      var spy = sandbox.spy(this.LinkInserter.prototype, 'setLink'),
          fakeEvent = $.Event('keyup'),
          $textInput = this.component.$valueTriggers.filter(':text').first();

      $textInput.val('bar').trigger(fakeEvent);

      expect(spy.calledWith('bar')).to.be.true;
    });

    it('should call the update link function when a radio trigger element\'s option is selected', function () {
      var spy = sandbox.spy(this.LinkInserter.prototype, 'setLink');

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

      this.eventsWithPromises.subscribe('linkinserter:link-published', spy);
      this.component.$insertLinks.first().click();
      expect(spy.called).to.be.true;
    });
  });

  describe('Publish link', function () {
    beforeEach(function (done) {
      this.component = new this.LinkInserter(this.$fixture);
      this.component.init();
      done();
    });

    it('should publish the link variable and emitter ID via the events bus', function() {
      var spy = sandbox.spy(),
          link = 'http://www.foo.com';

      this.eventsWithPromises.subscribe('linkinserter:link-published', spy);

      this.component.setLink(link);
      this.component.publishLink(link);

      expect(spy.args[0][0].link).to.equal(link);
      expect(spy.args[0][0].emitter).to.equal('add-link');
    });
  });

  describe('Track the currently selected link', function () {
    beforeEach(function (done) {
      this.component = new this.LinkInserter(this.$fixture);
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
