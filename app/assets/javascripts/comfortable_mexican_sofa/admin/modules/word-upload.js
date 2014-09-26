define('word-upload', [], function () {
  'use strict';
  return {
    init: function(options) {
      this.options = options;
      this.elements = {
        fileInputNode: this.options.fileInputNode,
        activateFileInputNode: this.options.activateFileInputNode,
        wordFormNode: this.options.wordFormNode
      };
      this.showConfirm = this.options.showConfirm || false;
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
      if (e.type === 'keydown' && e.keyCode !== 13) return;
      this.activateWordUploadForm();
    },

    activateWordUploadForm: function() {
      this.elements.fileInputNode.click();
    },

    submitWordUploadForm: function() {
      if (this.showConfirm) {
        if (!confirm('You will lose any modifications you may have made. Are you sure you wish to continue?')) {
          this.elements.wordFormNode.reset();
          return;
        }
      }
      this.elements.wordFormNode.submit();
    }
  };
});
