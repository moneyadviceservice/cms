//= require jquery.remotipart

define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

    var FileInputSubmitProto,
        defaultConfig = {};

    function FileInputSubmit($el, config) {
      FileInputSubmit.baseConstructor.call(this, $el, config, defaultConfig);
    };

    DoughBaseComponent.extend(FileInputSubmit);

    FileInputSubmitProto = FileInputSubmit.prototype;

    FileInputSubmitProto.init = function(initialised) {
      this.elements = {
        fileInputNode: document.querySelector('.js-word-upload-file-input'),
        activateFileInputNode: document.querySelector('.js-activate-word-upload-form'),
        wordFormNode: document.querySelector('.js-word-upload-form')
      };
      this.showConfirm = true;
      this.activateWordUploadForm = this.activateWordUploadForm.bind(this);
      this.submitWordUploadForm = this.submitWordUploadForm.bind(this);
      this.handleActivateNodeEvent = this.handleActivateNodeEvent.bind(this);
      this.setupEventListeners();
      this._initialisedSuccess(initialised);
    };

    FileInputSubmitProto.setupEventListeners = function() {
      this.elements.wordFormNode.addEventListener('change', this.submitWordUploadForm);
      this.elements.activateFileInputNode.addEventListener('click', this.handleActivateNodeEvent);
    };

    FileInputSubmitProto.handleActivateNodeEvent = function(e) {
      if (e.type === 'keydown' && e.keyCode !== 13) return;
      this.activateWordUploadForm();
    };

    FileInputSubmitProto.activateWordUploadForm = function() {
      this.elements.fileInputNode.click();
    };

    FileInputSubmitProto.submitWordUploadForm = function() {
      if (this.showConfirm) {
        if (!confirm('You will lose any modifications you may have made. Are you sure you wish to continue?')) {
          this.elements.wordFormNode.reset();
          return;
        }
      }
      this.elements.wordFormNode.children.upload_submit.click();
    };

    return FileInputSubmit;
});
