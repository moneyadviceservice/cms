define([
  'jquery',
  'DoughBaseComponent',
  'snippets-model'
], function (
  $,
  DoughBaseComponent,
  snippetsModel
) {
  'use strict';

  var SnippetInserterProto,
      defaultConfig = {
        selectors: {
          trigger: '[data-dough-snippetinserter-trigger]'
        },
        uiEvents: {
          'click [data-dough-snippetinserter-trigger]': '_handleTriggerClick'
        }
      };

  function SnippetInserter($el, config, customConfig, model) {
    SnippetInserter.baseConstructor.call(this, $el, config, defaultConfig);
    this.model = model || snippetsModel;
    this.context = this.$el.data('dough-snippetinserter-context');
    this.el = this.$el[0];
  }

  DoughBaseComponent.extend(SnippetInserter);

  SnippetInserter.componentName = 'SnippetInserter';

  SnippetInserterProto = SnippetInserter.prototype;

  SnippetInserterProto.init = function(initialised) {
    this._cacheComponentElements();
    this.$triggers.on('click', $.proxy(this._handleTriggerClick, this));
    this._initialisedSuccess(initialised);

    return this;
  };

  SnippetInserterProto._cacheComponentElements = function() {
    this.$triggers = $(this.config.selectors.trigger + '[data-dough-snippetinserter-context="' + this.context + '"]');
  };

  SnippetInserterProto._handleTriggerClick = function(e) {
    this._insertSnippet($(e.currentTarget).data('dough-snippetinserter-trigger'));
  };

  SnippetInserterProto._insertSnippet = function(snippetId) {
    this.insertAtCursor(this.el, this.model.get(snippetId));
  };

  SnippetInserterProto.insertAtCursor = function(field, text) {
    var val,
        selStart,
        caretPos;

    field.focus();
    val = field.value;
    selStart = field.selectionStart;
    caretPos = selStart + text.length;
    field.value = val.slice(0, selStart) + text + val.slice(field.selectionEnd);
    field.setSelectionRange(caretPos, caretPos);
  };

  return SnippetInserter;
});
