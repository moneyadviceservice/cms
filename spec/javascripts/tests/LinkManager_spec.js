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
      expect(this.component.$linkInputs.length).to.be.at.least(1);
      expect(this.component.$linkLabels.length).to.be.at.least(1);
      expect(this.component.$loader.length).to.equal(1);
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
      it('should activate the "page" tab trigger', function() {
        var spy = sandbox.spy();
        this.component.init();

        $('[data-dough-tab-selector-trigger="page"]').on('click', spy);
        this.component.changeTab('page');
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
      expect(spy.calledWith('page')).to.be.true;
    });

    it('should call the publishLink method', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, 'publishLink');

      this.component.init();
      this.component.setLink('page', 'foo');      
      this.component.$insertLinks.first().click();

      expect(spy.calledWith('foo')).to.be.true;

    });

    it('should call the clearInputs method', function() {
      var spy = sandbox.spy(this.LinkManager.prototype, 'clearInputs');
      this.component.init();
      this.component.$insertLinks.first().click();
      expect(spy.called).to.be.true;
    });
  });

  describe('Updating the link value inputs', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    afterEach(function () {
      this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="page"]').val('/foo');
      this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="external"]').val('http://foo.com');
      this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="file"]').val('foo.pdf');
    });

    it('should set the page link value inputs with the passed link', function () {
      this.component.setInputs('page', '/bar');
      expect(this.component.$linkInputs.filter('[data-dough-linkmanager-link-type="page"]').first().val()).to.equal('/bar');
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

      this.component.setLink('page', link);
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

      this.component.setLink('page', link);
      expect(this.component.linkValues['page']).to.eq(link);
    });
  });

  // describe('getPageLabel', function () {
  //   var server;

  //   beforeEach(function () {
  //     server = sandbox.useFakeServer();
  //     server.autoRespond = true;
  //     this.component = new this.LinkManager(this.$fixture);
  //   });

  //   afterEach(function () {
  //     server.restore();
  //   });

  //   describe('When a link is being edited', function () {
  //     describe('And the server returns a link type of page or file', function () {
  //       it('should call the server with the link', function (done) {});
  //       it('should call the _handleAjaxLabelDone method', function (done) {
  //         var link = 'test',
  //             spy = sinon.spy(this.LinkManager.prototype, '_handleAjaxLabelDone'),
  //             getLinkLabel;

  //         this.component.init();

  //         getLinkLabel = this.component._getPageLabel('twat');

  //         server.respondWith("GET", "/admin/links/" + link,
  //                          [200, { "Content-Type": "application/json" },
  //                           '{ "label": "Foo", "url": "/en/foo"}']);

  //         getLinkLabel.done(function(data) {
  //           console.dir(spy);
  //           expect(spy.called).to.be.true;
  //           done();
  //         });
  //       });  
  //     });
  //   });
  // });

  describe('getLink() Get a link from the linkValues hash', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });
    it('should return the correct link based type', function() {
      var link = 'http://foo.com';

      this.component.setLink('page', link);
      expect(this.component.getLink('page')).to.equal(link);
    });
  });

  describe('setLabels', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the label text based on the type', function() {
      var link = 'http://.foo.com',
          $fileLabel = this.component.$linkLabels.filter('[data-dough-linkmanager-label="file"]').first(),
          fileLabelText = $fileLabel.text(link);

      this.component.setLabels('file', link);

      expect($fileLabel.text()).to.equal(link);

      $fileLabel.text(fileLabelText);
    });
  });

  describe('showLoader', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should add the activeClass and remove the inactiveClass from the loader', function() {
      expect(this.component.$loader.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.true;
      expect(this.component.$loader.first().hasClass(this.component.config.selectors.activeClass)).to.be.false;
      this.component.showLoader();
      expect(this.component.$loader.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.false;
      expect(this.component.$loader.first().hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });
  });

  describe('hideLabels', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should add the inactiveClass and remove the activeClass from the loader', function() {
      this.component.showLoader();
      expect(this.component.$loader.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.false;
      expect(this.component.$loader.first().hasClass(this.component.config.selectors.activeClass)).to.be.true;
      this.component.hideLoader();
      expect(this.component.$loader.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.true;
      expect(this.component.$loader.first().hasClass(this.component.config.selectors.activeClass)).to.be.false;
    });
  });

  describe('showLabels', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should add the activeClass and remove the inactiveClass from the link label elements', function() {
      expect(this.component.$linkLabels.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.true;
      expect(this.component.$linkLabels.first().hasClass(this.component.config.selectors.activeClass)).to.be.false;
      this.component.showLabels();
      expect(this.component.$linkLabels.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.false;
      expect(this.component.$linkLabels.first().hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });
  });

  describe('hideLabels', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should add the inactiveClass and remove the activeClass from the link label elements', function() {
      this.component.showLabels();
      expect(this.component.$linkLabels.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.false;
      expect(this.component.$linkLabels.first().hasClass(this.component.config.selectors.activeClass)).to.be.true;
      this.component.hideLabels();
      expect(this.component.$linkLabels.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.true;
      expect(this.component.$linkLabels.first().hasClass(this.component.config.selectors.activeClass)).to.be.false;
    });
  });

  describe('Closing the dialog', function () {
    beforeEach(function (done) {
      this.component = new this.LinkManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should call the changeTab and clearInputs to reset the view', function() {
      var changeTabSpy = sandbox.spy(this.LinkManager.prototype, 'changeTab'),
          clearInputsSpy = sandbox.spy(this.LinkManager.prototype, 'clearInputs');

      this.component.close();

      expect(changeTabSpy.calledWith('page')).to.be.true;
      expect(clearInputsSpy.called).to.be.true;
    });
  });

});
