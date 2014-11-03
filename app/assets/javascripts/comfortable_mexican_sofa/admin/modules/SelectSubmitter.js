define(['jquery','DoughBaseComponent'], function ($, DoughBaseComponent) {
  'use strict';

  var SelectSubmitterProto,
      defaultConfig = {
        uiEvents: {
          'change': 'handleChange'
        }
      };

  function SelectSubmitter($el, config) {
    SelectSubmitter.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(SelectSubmitter);
  SelectSubmitterProto = SelectSubmitter.prototype;

  SelectSubmitterProto.init = function(initialised) {
    this._initialisedSuccess(initialised);

    return this;
  };

  SelectSubmitterProto.handleChange = function() {
    this.$el.closest('form').submit();
  };

  return SelectSubmitter;
});
