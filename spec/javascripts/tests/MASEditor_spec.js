describe('MAS Editor', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;

    requirejs([
      'jquery',
      'MASEditor',
      'phantom-shims'
    ],
    function (
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

  // afterEach(function() {
  //   this.sandbox.parentNode.removeChild(this.sandbox);
  // });

  describe('General', function () {
    beforeEach(function (done) {
      this.masEditor  = new this.MASEditor(this.$html);
      this.masEditor.init();
      done();
    });

    describe('Initialisation', function () {
      it('should enable the toolbar', function() {
        expect(this.masEditor.toolbarNode.classList.contains(this.classActive)).to.be.true;
      });
    });

    describe('Switching Edit mode', function() {
      it('allows the mode to be changed', function() {
        this.masEditor.mode = 'markdown';
        this.masEditor.changeMode('html');
        expect(this.masEditor.mode).to.equal('html');
      });

      it('ensures the active classes are switched when mode is changed', function() {
        this.masEditor
          .show(this.masEditor.htmlEditorNode)
          .hide(this.masEditor.markdownEditorNode)
          .changeMode('markdown');

        expect(this.masEditor.htmlEditorNode.classList.contains(this.classActive)).to.be.false;
        expect(this.masEditor.markdownEditorNode.classList.contains(this.classActive)).to.be.true;
      });

      // TODO: Add a test for button mode switching
      // it('ensures the selected mode button has an active class', function() {
      //   expect(this.masEditor.toolbarNode.classList.contains(this.classActive)).to.be.true;
      // });

      it('should add active class to the editor node', function() {
        this.masEditor.show(this.masEditor.htmlEditorNode);
        expect(this.masEditor.htmlEditorNode.classList.contains(this.classActive)).to.be.true;
      });

      it('should remove active class from the editor node', function() {
        this.masEditor.hide(this.masEditor.htmlEditorNode);
        expect(this.masEditor.htmlEditorNode.classList.contains(this.classActive)).to.be.false;
      });
    });


    describe('Events', function() {
      beforeEach(function (done) {
        this.masEditor = new this.MASEditor(this.$html);
        this.masEditor.init();
        done();
      });

      it('should catch form submit and route through handler function', function(){
        var spy = sinon.spy(this.masEditor, 'handleSubmit');
        expect(spy).to.have.been.called;
      });

      it('should call changeMode when a mode button is clicked', function(){
        var spy = sinon.spy(this.masEditor, 'changeMode');
        this.masEditor.switchModeTriggerNodes[0].click();
        expect(spy.called).to.be.true;
      });
    });
  });


});
