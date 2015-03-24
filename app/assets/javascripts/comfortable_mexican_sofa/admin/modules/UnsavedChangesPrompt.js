define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var UnsavedChangesPromptProto,
      defaultConfig = {
        defaultMessage: 'You have unsaved changes.'
      };

  function UnsavedChangesPrompt($el, config) {
    UnsavedChangesPrompt.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(UnsavedChangesPrompt);

  UnsavedChangesPromptProto = UnsavedChangesPrompt.prototype;

  UnsavedChangesPromptProto.init = function(initialised) {
    var customMessage = this.$el.data('dough-unsavedchangesprompt-message');
    this.message = customMessage? customMessage : this.config.defaultMessage;

    this._setupUIEvents();
    this._initialisedSuccess(initialised);
  };

  UnsavedChangesPromptProto._setupUIEvents = function() {
    this.$el.on('input change', $.proxy(this._handleInput, this));
    this.$el.on('submit', $.proxy(this._handleSubmit, this));
  };

  UnsavedChangesPromptProto._handleInput = function() {
    this._enablePrompt();
    this.$el.off('input change', this._handleInput);
  };

  UnsavedChangesPromptProto._handleSubmit = function() {
    this._disablePrompt();
  };

  UnsavedChangesPromptProto._handleUnload = function() {
    return this.message;
  };

  UnsavedChangesPromptProto._enablePrompt = function() {
    $(window).on('beforeunload', $.proxy(this._handleUnload, this));
  };

  UnsavedChangesPromptProto._disablePrompt = function() {
    $(window).off('beforeunload', this._handleUnload);
  };

  return UnsavedChangesPrompt;
});
