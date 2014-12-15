define([
  'jquery',
  'DoughBaseComponent',
  'eventsWithPromises'
], function (
  $,
  DoughBaseComponent,
  eventsWithPromises
) {
  'use strict';

  var TagManagerProto,
      defaultConfig = {
        selectors: {
          tagUsagePlaceholder: '[data-dough-tagmanager-usage-placeholder]',
          confirmDeleteButton: '[data-dough-tagmanager-delete]',
          closeButton: '[data-dough-dialog-close]',
          target: '[data-dough-tagmanager-target]'
        }
      };

  function TagManager($el, config) {
    TagManager.baseConstructor.call(this, $el, config, defaultConfig);
    this.context = this.$el.attr('data-dough-tagmanager-context');
  }

  DoughBaseComponent.extend(TagManager);

  TagManagerProto = TagManager.prototype;

  TagManagerProto.init = function(initialised) {
    this._cacheComponentElements();
    this._setupAppEvents();
    this._setupUIEvents();
    this._initialisedSuccess(initialised);
  };

  TagManagerProto._cacheComponentElements = function() {
    var $body = $('body');
    this.$deleteTarget = this.$el;
    this.$target = $body.find(this.config.selectors.target);
    this.$tagUsagePlaceholders = this.$target.find(this.config.selectors.tagUsagePlaceholder);
    this.$confirmDeleteButtons = this.$target.find(this.config.selectors.confirmDeleteButton);
    this.$closeButtons = this.$target.find(this.config.selectors.closeButton);
  };

  TagManagerProto._setupAppEvents = function() {
    eventsWithPromises.subscribe('dialog:shown', $.proxy(this._handleShown, this));
  };

  TagManagerProto._setupUIEvents = function() {
    this.$confirmDeleteButtons.on('click', $.proxy(this._handleDelete, this));
  };

  TagManagerProto._setUsagePlaceholderContent = function(usage) {
    this.$tagUsagePlaceholders.text(usage);
  };

  TagManagerProto._handleShown = function() {
    this._setUsagePlaceholderContent(this.$deleteTarget.attr('data-dough-tagmanager-usage'));
  };

  TagManagerProto._handleDelete = function() {
    eventsWithPromises.publish('tagmanager:delete', {
      emitter: this.context,
      $trigger: this.$el
    });

    eventsWithPromises.publish('dialog:close', {
      emitter: this.context
    });
  };

  return TagManager;
});
