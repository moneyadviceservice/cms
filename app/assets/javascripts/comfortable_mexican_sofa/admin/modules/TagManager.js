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
    this.id = this.$el.attr('data-dough-tagmanager-id');
    this._handleDelete = $.proxy(this._handleDelete, this);
  }

  DoughBaseComponent.extend(TagManager);

  TagManager.componentName = 'TagManager';

  TagManagerProto = TagManager.prototype;

  TagManagerProto.init = function(initialised) {
    this._cacheComponentElements();
    this._setupUIEvents();
    this._initialisedSuccess(initialised);
  };

  TagManagerProto._cacheComponentElements = function() {
    var $body = $('body');
    this.$trigger = this.$el;
    this.$target = $body.find(this.config.selectors.target);
    this.$tagUsagePlaceholders = this.$target.find(this.config.selectors.tagUsagePlaceholder);
    this.$confirmDeleteButtons = this.$target.find(this.config.selectors.confirmDeleteButton);
    this.$closeButtons = this.$target.find(this.config.selectors.closeButton);
  };

  TagManagerProto._setupUIEvents = function() {
    this.$trigger.on('click', $.proxy(this.show, this));
  };

  TagManagerProto._setUsagePlaceholderContent = function(usage) {
    this.$tagUsagePlaceholders.text(usage);
  };

  TagManagerProto._handleDelete = function() {
    eventsWithPromises.publish('tagmanager:delete', {
      emitter: this.context,
      id: this.id
    });

    eventsWithPromises.publish('dialog:close', {
      emitter: this.context
    });
  };

  TagManagerProto.show = function() {
    eventsWithPromises.publish('dialog:show', {
      emitter: this.context,
      id: this.id
    });

    this.$confirmDeleteButtons.off('click', this._handleDelete).on('click', this._handleDelete);
    this._setUsagePlaceholderContent(this.$trigger.attr('data-dough-tagmanager-tag-usage'));
  };

  return TagManager;
});
