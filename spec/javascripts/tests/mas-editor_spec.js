describe('MAS Editor', function () {
  'use strict';

  beforeEach(function(done) {
    var self = this;
    requirejs([
      'mas-editor',
      'phantom-shims'
    ],
    function (
      masEditor
    ) {
      self.sandbox = document.createElement('div');
      self.sandbox.innerHTML = window.__html__['spec/javascripts/fixtures/mas-editor.html'];
      document.body.appendChild(self.sandbox);
      self.classActive = 'is-active';

      self.masEditor = masEditor;
      self.masEditor.init({
        cmsFormNode: self.sandbox.querySelector('.js-edit-form'),
        toolbarNode: self.sandbox.querySelector('.js-html-editor-toolbar'),
        htmlEditorNode: self.sandbox.querySelector('.js-html-editor'),
        htmlEditorContentNode: document.querySelector('.js-html-editor-content'),
        markdownEditorNode: self.sandbox.querySelector('.js-markdown-editor'),
        markdownEditorContentNode: self.sandbox.querySelector('.js-markdown-editor-content'),
        switchModeButtonNodes: document.querySelectorAll('.js-switch-mode')
      });

      done();
    }, done);
  });

  afterEach(function() {
    this.sandbox.parentNode.removeChild(this.sandbox);
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

    it('should throw an error if an unknown mode is selected', function() {
      expect(function(){this.masEditor.changeMode('foo');}.bind(this)).to.throw('That conversion isn\'t supported');
    });

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
    it('should catch form submit and route through handler function', function(){
      var spy = sinon.spy(this.masEditor, 'handleSubmit');
      // TODO Currently causing an infinite loop
      // this.masEditor.cmsFormNode.submit();
      expect(this.masEditor.handleSubmit).to.have.been.called;
    });

    it('should call changeMode when a mode button is clicked', function(){
      var spy = sinon.spy(this.masEditor, 'changeMode');
      this.masEditor.switchModeButtonNodes[0].click();
      expect(spy.called).to.be.true;
    });
  });

});
