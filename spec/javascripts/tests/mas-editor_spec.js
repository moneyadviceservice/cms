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
      var sandbox = document.createElement('div');
      sandbox.innerHTML = window.__html__['spec/javascripts/fixtures/mas-editor.html'];
      document.body.appendChild(sandbox);
      self.sandbox = sandbox;
      self.cmsFormNode = sandbox.querySelector('.js-edit-form');
      self.toolbarNode = sandbox.querySelector('.js-html-editor-toolbar');
      self.markdownEditorNode = sandbox.querySelector('.js-markdown-editor');
      self.markdownEditorContentNode = sandbox.querySelector('.js-markdown-editor-content');
      self.htmlEditorNode = sandbox.querySelector('.js-html-editor');
      self.htmlEditorContentNode = document.querySelector('.js-html-editor-content');
      self.switchModeButtonNodes = document.querySelectorAll('.js-switch-mode');
      self.classActive = 'is-active';

      self.masEditor = masEditor;
      self.masEditor.init({
        cmsFormNode: self.cmsFormNode,
        toolbarNode: self.toolbarNode,
        htmlEditorNode: self.htmlEditorNode,
        htmlEditorContentNode: self.htmlEditorContentNode,
        markdownEditorNode: self.markdownEditorNode,
        markdownEditorContentNode: self.markdownEditorContentNode,
        switchModeButtonNodes: self.switchModeButtonNodes
      });

      done();
    }, done);
  });

  afterEach(function() {
    this.sandbox.parentNode.removeChild(this.sandbox);
  });

  describe('Switching Edit mode', function() {
    it('allows the mode to be changed', function() {
      this.masEditor.mode = 'markdown';
      this.masEditor.changeMode('html');
      expect(this.masEditor.mode).to.equal('html');
    });

    it('ensures the active classes are switched when mode is changed', function() {
      this.masEditor
        .show(this.htmlEditorNode)
        .hide(this.markdownEditorNode)
        .changeMode('markdown');

      expect(this.htmlEditorNode.classList.contains(this.classActive)).to.be.false;
      expect(this.markdownEditorNode.classList.contains(this.classActive)).to.be.true;
    });

    // TODO: Add a test for button mode switching
    // it('ensures the selected mode button has an active class', function() {
    //   expect(this.toolbarNode.classList.contains(this.classActive)).to.be.true;
    // });

    it('should throw an error if an unknown mode is selected', function() {
      expect(function(){this.masEditor.changeMode('foo');}.bind(this)).to.throw('That conversion isn\'t supported');
    });

    it('should add active class to the editor node', function() {
      this.masEditor.show(this.htmlEditorNode);
      expect(this.htmlEditorNode.classList.contains(this.classActive)).to.be.true;
    });

    it('should remove active class from the editor node', function() {
      this.masEditor.hide(this.htmlEditorNode);
      expect(this.htmlEditorNode.classList.contains(this.classActive)).to.be.false;
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
      this.switchModeButtonNodes[0].click();
      expect(spy.called).to.be.true;
    });
  });

});
