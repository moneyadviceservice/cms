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
      self.cmsFormNode = sandbox.querySelector('#edit_page');
      self.toolbarNode = sandbox.querySelector('.js-html-editor-toolbar');
      self.markdownEditorNode = sandbox.querySelector('textarea[data-cms-rich-text]');
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
        switchModeButtonNodes: self.switchModeButtonNodes
      });

      done();
    }, done);
  });

  afterEach(function() {
    this.sandbox.parentNode.removeChild(this.sandbox);
  });

  describe('Setup', function() {
    it('should append the HTML editor to the same parent as the Markdown editor', function() {
      expect(this.htmlEditorNode.parentNode).to.equal(this.markdownEditorNode.parentNode);
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
        .show(this.htmlEditorNode)
        .hide(this.markdownEditorNode)
        .changeMode('markdown');

      expect(this.htmlEditorNode.classList.contains(this.classActive)).to.be.false;
      expect(this.markdownEditorNode.classList.contains(this.classActive)).to.be.true;
    });

    it('should add active class to a node', function() {
      this.masEditor.show(this.htmlEditorNode);
      expect(this.htmlEditorNode.classList.contains(this.classActive)).to.be.true;
    });

    it('should remove active class from a node', function() {
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
