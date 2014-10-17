define(['jquery','DoughBaseComponent','chosen'], function ($, DoughBaseComponent, chosen) {
  'use strict';

  var AutoCompleteProto,
      defaultConfig = {};

  function AutoComplete($el, config) {
    AutoComplete.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(AutoComplete);
  AutoCompleteProto = AutoComplete.prototype;

  AutoCompleteProto.init = function(initialised) {
    this.$el.chosen({
      placeholder_text_multiple: this.$el.attr('data-dough-placeholder-text') || 'Enter text',
      width: "100%",
      single_backstroke_delete: false,
      inherit_select_classes: true
    });

    this._initialisedSuccess(initialised);

    return this;
  };

  return AutoComplete;
});
