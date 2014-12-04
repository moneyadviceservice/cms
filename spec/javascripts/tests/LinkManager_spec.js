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
    this.eventsWithPromises.unsubscribeAll();
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

    it('should call handleShown when the cmseditor:link-published event is published', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, '_handleShown');

      this.component.init();
      this.eventsWithPromises.publish('cmseditor:link-published', {
        emitter: 'add-link'
      });
      expect(spy.called).to.be.true;
    });

    it('should call the close method when the dialog:close or dialog:cancelled event with matching emitter context is published', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, 'close'),
          eventData = {
            emitter: 'add-link'
          };

      this.component.init();

      this.eventsWithPromises.publish('dialog:closed', eventData);
      this.eventsWithPromises.publish('dialog:cancelled', eventData);

      expect(spy.callCount).to.equal(2);
    });
  });

  describe('When dialog is opened', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      done();
    });

    it('cmseditor:link-published event\'s emitter ID should be the same as the LinkManager\'s', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, '_handleShown');

      this.component.init();
      this.eventsWithPromises.publish('cmseditor:link-published', {
        emitter: 'add-link'
      });
      expect(spy.args[0][0].emitter).to.equal('add-link');
    });

    describe('Editing existing link', function () {
      it('should call the setup function with "existing" param and link', function() {
        var spy = sandbox.spy(this.LinkManager.prototype, '_setup');

        this.component.init();
        this.eventsWithPromises.publish('cmseditor:link-published', {
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
        this.eventsWithPromises.publish('cmseditor:link-published', {
          emitter: 'add-link'
        });

        expect(spy.calledWith('new')).to.be.true;
      });
    });
  });

  describe('UI Events', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      done();
    });

    describe('When link is edited', function() {
      it('should activate a tab trigger', function() {
        var spy = sandbox.spy();
        this.component.init();

        $('[data-dough-tab-selector-trigger]').on('click', spy);
        this.component.changeTab('external');
        expect(spy.called).to.be.true;
      });
    });

    describe('When a new link is called', function () {
      it('should activate the "internal" tab trigger', function() {
        var spy = sandbox.spy();
        this.component.init();

        $('[data-dough-tab-selector-trigger="internal"]').on('click', spy);
        this.component.changeTab('internal');
        expect(spy.called).to.be.true;
      });
    });

    describe('When a link is being edited', function () {
      it('should call the update link function when a text input trigger element\'s value is updated', function () {
        var spy = sandbox.spy(this.LinkManager.prototype, 'setLink'),
            fakeEvent = $.Event('keyup'),
            $textInput,
            textInputType,
            textInputVal;
        
        this.component.init();

        $textInput = this.component.$valueTriggers.filter(':text').first();
        textInputType = $textInput.attr('data-dough-linkmanager-link-type');
        textInputVal = $textInput.val();

        $textInput.attr('data-dough-linkmanager-link-type', 'external');
        $textInput.val('bar').trigger(fakeEvent);

        expect(spy.calledWith('external','bar')).to.be.true;

        $textInput.attr('data-dough-linkmanager-link-type', textInputType).val(textInputVal);
      });

      it('should call the update link function when a radio trigger element\'s option is selected', function () {
        var spy = sandbox.spy(this.LinkManager.prototype, 'setLink'),
            $radioInput,
            radioInputType,
            radioInputVal;

        this.component.init();

        $radioInput = this.component.$valueTriggers.filter(':radio').first();
        radioInputType = $radioInput.attr('data-dough-linkmanager-link-type');
        radioInputVal = $radioInput.val();

        $radioInput.attr('data-dough-linkmanager-link-type', 'external');
        $radioInput  
          .val('bar')
          .click();

        expect(spy.calledWith('external','bar')).to.be.true;

        $radioInput.attr('data-dough-linkmanager-link-type', radioInputType).val(radioInputVal);
      });
    });

    describe('When an Insert Link button is clicked', function () {
      it('should call the _handleInsertLink method', function() {
        var spy = sandbox.spy(this.LinkManager.prototype, '_handleInsertLink');
        this.component.init();
        this.component.$insertLinks.first().click();
        expect(spy.called).to.be.true;
      });
    });
  });

  describe('Insert Link handler', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      done();
    });

    it('should call the changeTab method', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, 'changeTab');
      this.component.init();
      this.component.$insertLinks.first().click();
      expect(spy.calledWith('internal')).to.be.true;
    });

    it('should call the publishLink method', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, 'publishLink'),
          $insertLink;

      this.component.init();
      this.component.setLink('internal', 'foo');      
      this.component.$insertLinks.first().click();

      expect(spy.calledWith('foo')).to.be.true;

    });

    it('should call the clearInputs method', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, 'clearInputs');
      this.component.init();
      this.component.$insertLinks.first().click();
      expect(spy.called).to.be.true;
    });


      // it('should execute the publish the link when an insertlink button is selected', function() {
      //   var spy = sandbox.spy(this.LinkManager.prototype, '_handleLink');

      //   this.component.$valueTriggers
      //     .filter(':radio')
      //     .first()
      //     .val('foo')
      //     .click();

      //   this.eventsWithPromises.subscribe('linkmanager:link-published', spy);
      //   this.component.$insertLinks.first().click();
      //   expect(spy.called).to.be.true;
      // });
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

      this.component.setLink('internal', link);
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

      this.component.setLink('internal', link);
      expect(this.component.linkValues['internal']).to.eq(link);
    });
  });

  describe('Get a link from the linkValues hash', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });
    it('should return the correct link based type', function() {
      var link = 'http://foo.com';

      this.component.setLink('internal', link);
      expect(this.component.getLink('internal')).to.equal(link);
    });
  });

  describe('Close', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should call the changeTab and clearInputs to reset the view', function() {
      var changeTabSpy = sandbox.spy(this.LinkManager.prototype, 'changeTab'),
          clearInputsSpy = sandbox.spy(this.LinkManager.prototype, 'clearInputs');

      this.component.close();

      expect(changeTabSpy.calledWith('internal')).to.be.true;
      expect(clearInputsSpy.called).to.be.true;
    });
  });

});
