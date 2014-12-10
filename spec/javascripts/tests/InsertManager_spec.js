describe('InsertManager', function () {
  'use strict';

  var sandbox;

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'phantom-shims',
      'jquery',
      'InsertManager',
      'eventsWithPromises'
    ],
    function (
      phantomShims,
      $,
      InsertManager,
      eventsWithPromises
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/InsertManager.html']).appendTo('body');
      self.$fixture = self.$html.find('[data-dough-component="InsertManager"]');
      self.InsertManager = InsertManager;
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
      this.component = new this.InsertManager(this.$fixture);
      done();
    });

    it('should cache the insert link, tab trigger, value triggers and tab trigger element references', function() {
      this.component.init();
      expect(this.component.$tabTriggers.length).to.be.at.least(1);
      expect(this.component.$insertButtons.length).to.be.at.least(1);
      expect(this.component.$valueTriggers.length).to.be.at.least(1);
      expect(this.component.$insertInputs.length).to.be.at.least(1);
      expect(this.component.$currentItemLabels.length).to.be.at.least(1);
      expect(this.component.$loader.length).to.equal(1);
    });
  });

  describe('App Events', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      done();
    });

    it('should call handleShown when the cmseditor:insert-published event is published', function() {
      var spy = sandbox.spy(this.InsertManager.prototype, '_handleShown');

      this.component.init();
      this.eventsWithPromises.publish('cmseditor:insert-published', {
        emitter: 'add-link'
      });
      expect(spy.called).to.be.true;
    });

    it('should call the close method when the dialog:close or dialog:cancelled event with matching emitter context is published', function() {
      var spy = sandbox.spy(this.InsertManager.prototype, 'close'),
          eventData = {
            emitter: 'add-link'
          };

      this.component.init();

      this.eventsWithPromises.publish('dialog:closed', eventData);
      this.eventsWithPromises.publish('dialog:cancelled', eventData);

      expect(spy.callCount).to.equal(2);
    });
  });

  describe('UI Events', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      done();
    });

    describe('When value is edited', function() {
      it('should activate a tab trigger', function() {
        var spy = sandbox.spy();
        this.component.init();

        $('[data-dough-tab-selector-trigger]').on('click', spy);
        this.component.changeTab('external');
        expect(spy.called).to.be.true;
      });
    });

    describe('When new value is called', function () {
      it('should activate the "page" tab trigger', function() {
        var spy = sandbox.spy();
        this.component.init();

        $('[data-dough-tab-selector-trigger="page"]').on('click', spy);
        this.component.changeTab('page');
        expect(spy.called).to.be.true;
      });
    });

    describe('When a value is being edited', function () {
      it('should call the setValue function when a text input trigger element\'s value is updated', function () {
        var spy = sandbox.spy(this.InsertManager.prototype, 'setValue'),
            fakeEvent = $.Event('keyup'),
            $textInput,
            textInputType,
            textInputVal;

        this.component.init();

        $textInput = this.component.$valueTriggers.filter(':text').first();
        textInputType = $textInput.attr('data-dough-insertmanager-insert-type');
        textInputVal = $textInput.val();

        $textInput.attr('data-dough-insertmanager-insert-type', 'external');
        $textInput.val('bar').trigger(fakeEvent);

        expect(spy.calledWith('external','bar')).to.be.true;

        $textInput.attr('data-dough-insertmanager-insert-type', textInputType).val(textInputVal);
      });

      it('should call the setValue function when a radio trigger element\'s option is selected', function () {
        var spy = sandbox.spy(this.InsertManager.prototype, 'setValue'),
            $radioInput,
            radioInputType,
            radioInputVal;

        this.component.init();

        $radioInput = this.component.$valueTriggers.filter(':radio').first();
        radioInputType = $radioInput.attr('data-dough-insertmanager-insert-type');
        radioInputVal = $radioInput.val();

        $radioInput.attr('data-dough-insertmanager-insert-type', 'external');
        $radioInput
          .val('bar')
          .click();

        expect(spy.calledWith('external','bar')).to.be.true;

        $radioInput.attr('data-dough-insertmanager-insert-type', radioInputType).val(radioInputVal);
      });
    });

    describe('When an Insert Value button is clicked', function () {
      it('should call the _handleInsertValue method', function() {
        var spy = sandbox.spy(this.InsertManager.prototype, '_handleInsertValue');
        this.component.init();
        this.component.$insertButtons.first().click();
        expect(spy.called).to.be.true;
      });
    });
  });

  describe('Insert Value handler', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      done();
    });

    it('should call the changeTab method', function() {
      var spy = sandbox.spy(this.InsertManager.prototype, 'changeTab');

      this.component.init();
      this.component._handleShown({
        emitter: 'add-link'
      });
      this.component.$insertButtons.first().click();

      expect(spy.calledWith('page')).to.be.true;
    });

    it('should call the publishValue method', function() {
      var spy = sandbox.spy(this.InsertManager.prototype, 'publishValue'),
          eventData = {type: 'page', val: 'foo', emitter: 'add-link'};

      this.component.init();

      this.component.setValue('page', 'foo');
      this.component.$insertButtons.first().click();
      expect(spy.args[0][0]).to.eql(eventData);

    });

    it('should call the clearInputs method', function() {
      var spy = sandbox.spy(this.InsertManager.prototype, 'clearInputs');
      this.component.init();

      this.component._handleShown({
        emitter: 'add-link'
      });

      this.component.$insertButtons.first().click();
      expect(spy.called).to.be.true;
    });
  });

  describe('Updating the insert type value inputs', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      this.component.init();
      done();
    });

    afterEach(function () {
      this.component.$insertInputs.filter('[data-dough-insertmanager-insert-type="page"]').val('/foo');
      this.component.$insertInputs.filter('[data-dough-insertmanager-insert-type="external"]').val('http://foo.com');
      this.component.$insertInputs.filter('[data-dough-insertmanager-insert-type="file"]').val('foo.pdf');
    });

    it('should set the page link value inputs with the passed link', function () {
      this.component.setInputs('page', '/bar');
      expect(this.component.$insertInputs.filter('[data-dough-insertmanager-insert-type="page"]').first().val()).to.equal('/bar');
    });

    it('should set the external link value inputs with the passed link', function () {
      this.component.setInputs('external', 'http://bar.com');
      expect(this.component.$insertInputs.filter('[data-dough-insertmanager-insert-type="external"]').first().val()).to.equal('http://bar.com');
    });

    it('should set the file link value inputs with the passed link', function () {
      this.component.setInputs('file', 'bar.pdf');
      expect(this.component.$insertInputs.filter('[data-dough-insertmanager-insert-type="file"]').first().val()).to.equal('bar.pdf');
    });
  });

  describe('Publish value', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should publish the value and emitter id (optional: and any other params) via the events bus', function() {
      var spy = sandbox.spy(),
          link = 'http://www.foo.com',
          eventData = {type: 'page', link: link, emitter: 'add-link'};

      this.eventsWithPromises.subscribe('insertmanager:insert-published', spy);

      this.component.setValue('page', link);
      this.component.publishValue(eventData);
      expect(spy.args[0][0]).to.eql(eventData);
    });
  });

  describe('Save the value to itemValues', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the link variable', function() {
      var link = 'http://foo.com';

      this.component.setValue('page', link);
      expect(this.component.itemValues['page']).to.eq(link);
    });
  });

  describe.skip('getPageLabel', function () {
    var server;

    beforeEach(function () {
      server = sandbox.useFakeServer();
      server.autoRespond = true;
      this.component = new this.InsertManager(this.$fixture);
    });

    afterEach(function () {
      server.restore();
    });

    describe('When a value is being edited', function () {
      describe('And the server returns a value type of page or file', function () {
        it('should call the server with the value', function (done) {});
        it('should call the _handleAjaxLabelDone method', function (done) {
          var link = 'test',
              spy = sinon.spy(this.InsertManager.prototype, '_handleAjaxLabelDone'),
              getValueLabel;

          this.component.init();

          getValueLabel = this.component._getPageLabel('test');

          server.respondWith("GET", "/admin/links/?id=" + link,
                           [200, { "Content-Type": "application/json" },
                            '{ "label": "Foo", "url": "/en/foo"}']);

          getValueLabel.then(function(data) {
            expect(spy.called).to.be.true;
            done();
          });
        });
      });
    });
  });

  describe('getValue() Get a link from the itemValues hash', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      this.component.init();
      done();
    });
    it('should return the correct value based on the type', function() {
      var link = 'http://foo.com';

      this.component.setValue('page', link);
      expect(this.component.getValue('page')).to.equal(link);
    });
  });

  describe('setLabels()', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should set the label text based on the type', function() {
      var link = 'http://.foo.com',
          $fileLabel = this.component.$currentItemLabels.filter('[data-dough-insertmanager-label="file"]').first(),
          fileLabelText = $fileLabel.text(link);

      this.component.setLabels('file', link);

      expect($fileLabel.text()).to.equal(link);

      $fileLabel.text(fileLabelText);
    });
  });

  describe('showLoader', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
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
      this.component = new this.InsertManager(this.$fixture);
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
      this.component = new this.InsertManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should add the activeClass and remove the inactiveClass from the item label elements', function() {
      expect(this.component.$currentItemLabels.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.true;
      expect(this.component.$currentItemLabels.first().hasClass(this.component.config.selectors.activeClass)).to.be.false;
      this.component.showLabels();
      expect(this.component.$currentItemLabels.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.false;
      expect(this.component.$currentItemLabels.first().hasClass(this.component.config.selectors.activeClass)).to.be.true;
    });
  });

  describe('hideLabels', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      this.component.init();
      done();
    });

    it('should add the inactiveClass and remove the activeClass from the item label elements', function() {
      this.component.showLabels();
      expect(this.component.$currentItemLabels.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.false;
      expect(this.component.$currentItemLabels.first().hasClass(this.component.config.selectors.activeClass)).to.be.true;
      this.component.hideLabels();
      expect(this.component.$currentItemLabels.first().hasClass(this.component.config.selectors.inactiveClass)).to.be.true;
      expect(this.component.$currentItemLabels.first().hasClass(this.component.config.selectors.activeClass)).to.be.false;
    });
  });

  describe('Closing the dialog', function () {
    beforeEach(function (done) {
      this.component = new this.InsertManager(this.$fixture);
      done();
    });

    it('should call the changeTab and clearInputs to reset the view', function() {
      var changeTabSpy = sandbox.spy(this.InsertManager.prototype, 'changeTab'),
          clearInputsSpy = sandbox.spy(this.InsertManager.prototype, 'clearInputs');

      this.component.init();
      this.component._handleShown({
        emitter: 'add-link'
      });
      this.component.close();

      expect(changeTabSpy.calledWith('page')).to.be.true;
      expect(clearInputsSpy.called).to.be.true;
    });

    it('should return the close function early if the insertManager has already been closed', function() {
      var spy = sandbox.spy(this.InsertManager.prototype, 'close');

      this.component.init();
      this.component._handleShown({
        emitter: 'add-link'
      });

      expect(this.component.open).to.be.true;

      this.component.close();
      this.component.close();

      expect(spy.returnValues[1]).to.be.false;
      expect(this.component.open).to.be.false;
    });
  });

});
