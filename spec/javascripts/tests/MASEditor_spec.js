describe('MASEditor', function() {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'MASEditor',
      'phantom-shims'
    ],
    function(
      $,
      MASEditor
    ) {
      self.$html = $(window.__html__['spec/javascripts/fixtures/MASEditor.html']);
      self.classActive = 'is-active';
      self.MASEditor = MASEditor;
      $('body').append(self.$html);
      done();
    }, done);
  });

  afterEach(function() {
    this.$html.remove();
  });

  describe('General', function() {
    describe('Initialisation', function() {
      beforeEach(function(done) {
        this.masEditor  = new this.MASEditor(this.$html);
        this.masEditor.init();
        done();
      });
      it('should enable the toolbar', function() {
        expect(this.masEditor.$htmlToolbar.hasClass(this.classActive)).to.be.true;
      });
    });

    describe('Switching Edit mode', function() {
      beforeEach(function(done) {
        this.masEditor  = new this.MASEditor(this.$html);
        this.masEditor.init();
        done();
      });
      it('allows the mode to be changed', function() {
        this.masEditor.mode = 'markdown';
        this.masEditor.changeMode('html');
        expect(this.masEditor.mode).to.equal('html');
      });

      it('ensures the active classes are switched when mode is changed', function() {
        this.masEditor
          .show(this.masEditor.$htmlContainer)
          .hide(this.masEditor.$markdownContainer)
          .changeMode('markdown');

        expect(this.masEditor.$htmlContainer.hasClass(this.classActive)).to.be.false;
        expect(this.masEditor.$htmlToolbar.hasClass(this.classActive)).to.be.false;
        expect(this.masEditor.$markdownContainer.hasClass(this.classActive)).to.be.true;
        expect(this.masEditor.$markdownToolbar.hasClass(this.classActive)).to.be.true;

        this.masEditor.changeMode('html');

        expect(this.masEditor.$htmlContainer.hasClass(this.classActive)).to.be.true;
        expect(this.masEditor.$htmlToolbar.hasClass(this.classActive)).to.be.true;
        expect(this.masEditor.$markdownContainer.hasClass(this.classActive)).to.be.false;
        expect(this.masEditor.$markdownToolbar.hasClass(this.classActive)).to.be.false;
      });

      it('should add active class to the editor node', function() {
        this.masEditor.show(this.masEditor.$htmlContainer);
        expect(this.masEditor.$htmlContainer.hasClass(this.classActive)).to.be.true;
      });

      it('should remove active class from the editor node', function() {
        this.masEditor.hide(this.masEditor.$htmlContainer);
        expect(this.masEditor.$htmlContainer.hasClass(this.classActive)).to.be.false;
      });
    });

  });

  describe('Events', function() {
    beforeEach(function(done) {
      this.handleFormSubmitSpy = sinon.spy(this.MASEditor.prototype, '_handleFormSubmit');
      this.masEditor  = new this.MASEditor(this.$html);
      this.masEditor.init();
      done();
    });

    afterEach(function() {
      this.handleFormSubmitSpy.restore();
    });

    it('should catch form submit and route through handler function', function(){
      this.masEditor.$cmsForm.on('submit', function(e) {
        e.preventDefault();
      });
      this.masEditor.$cmsFormSubmit.click();
      expect(this.handleFormSubmitSpy.called).to.be.true;
    });

    it('should convert HTML content to Markdown before saving', function(){
      this.masEditor.mode = 'html';
      this.masEditor.$htmlContent.html('<h2>Title</h2>');
      this.masEditor.$cmsForm.on('submit', function(e) {
        e.preventDefault();
      });
      this.masEditor.$cmsFormSubmit.click();
      expect(this.handleFormSubmitSpy.called).to.be.true;
      expect(this.masEditor.$markdownContent.val()).to.equal('## Title');
    });

    it('should call changeMode when a mode button is clicked', function(){
      var spy = sinon.spy(this.masEditor, 'changeMode');
      this.masEditor.$switchModeContainer.find('[value="markdown"]').click();
      expect(spy.called).to.be.true;
    });
  });

});
