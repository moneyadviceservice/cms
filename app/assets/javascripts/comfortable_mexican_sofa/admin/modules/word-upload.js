define('word-upload', [], function () {
  'use strict';
  return {
    init: function(options) {
      this.options = options;
      this.elements = {
        fileInputNode: options.fileInputNode,
        activateFileInputNode: options.activateFileInputNode,
        wordFormNode: options.wordFormNode
      }
      this.activateWordUploadForm = this.activateWordUploadForm.bind(this);
      this.submitWordUploadForm = this.submitWordUploadForm.bind(this);
      this.handleActivateNodeEvent = this.handleActivateNodeEvent.bind(this);
      this.setupEventListeners();
    },

    setupEventListeners: function() {
      this.elements.wordFormNode.addEventListener('change', this.submitWordUploadForm);
      this.elements.activateFileInputNode.addEventListener('click', this.handleActivateNodeEvent);
    },

    handleActivateNodeEvent: function(e) {
      if(e.type === 'keydown' && e.keyCode !== 13) return;
      this.activateWordUploadForm();
    },

    activateWordUploadForm: function() {
      this.elements.fileInputNode.click();
    },

    submitWordUploadForm: function() {
      this.elements.wordFormNode.submit();
    }
  };
});
