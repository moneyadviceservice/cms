define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var FieldDisabledStateTogglerProto,
      defaultConfig = {
        disabledAttr: 'disabled',
        selectors: {
          target: '[data-dough-field-disabled-state-toggler-target]'
        }
      };

  function FieldDisabledStateToggler($el, config) {
    FieldDisabledStateToggler.baseConstructor.call(this, $el, config, defaultConfig);
    var customDisabledAttr = this.$el.data('dough-field-disabled-state-toggler-attribute');
    this.disabledAttr = customDisabledAttr? customDisabledAttr : this.config.disabledAttr;
  }

  DoughBaseComponent.extend(FieldDisabledStateToggler);

  FieldDisabledStateToggler.componentName = 'FieldDisabledStateToggler';

  FieldDisabledStateTogglerProto = FieldDisabledStateToggler.prototype;

  FieldDisabledStateTogglerProto.init = function(initialised) {
    this.$form = this.$el.closest('form');

    this._setupHotSpot();
    this._setupUIEvents();

    this._initialisedSuccess(initialised);
  };

  FieldDisabledStateTogglerProto._setupUIEvents = function() {
    $(document).on('keyup', $.proxy(this._handleKeyPress, this));
    this.$hotspot.on('dblclick', $.proxy(this._handleDblClick, this));
    this.$form.on('click keyup', $.proxy(this._handleFocusChange, this));
  };

  FieldDisabledStateTogglerProto._setupHotSpot = function() {
    this.$wrapper = $('<div />').css({
      'position': 'relative'
    });
    this.$el.wrap(this.$wrapper);
    this.$hotspot = $('<span />').css({
      'position': 'absolute',
      'top': 0,
      'right': 0,
      'bottom': 0,
      'left': 0
    });
    this.$el.parent().append(this.$hotspot);
  };

  FieldDisabledStateTogglerProto._handleDblClick = function() {
    this.setDisabledState(false);
    this.$el.focus();
  };

  FieldDisabledStateTogglerProto._handleKeyPress = function(e) {
    if(e.keyCode === 27) {
      this.setDisabledState(true);
    }
  };

  FieldDisabledStateTogglerProto._handleFocusChange = function(e) {
    if(e.currentTarget === this.$hotspot[0] || e.keyCode && e.keyCode !== 9) return;

    if(!$(e.target).is(this.$el)) {
      this.setDisabledState(true);
    }
  };

  FieldDisabledStateTogglerProto.setDisabledState = function(disabled) {
    if(disabled) {
      this.$el.attr(this.disabledAttr, true);
      this.$hotspot.show();
    }
    else {
      this.$el.removeAttr(this.disabledAttr);
      this.$hotspot.hide();
    }
  };

  return FieldDisabledStateToggler;
});
