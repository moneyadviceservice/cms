define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var CharacterCounterProto,
      defaultConfig = {
        selectors: {
          indicator: '[data-dough-character-counter-indicator]',
          warning: '[data-dough-character-counter-warning]',
          activeClass: 'is-active',
          aboveMaxClass: 'is-above-max',
          zeroClass: 'is-zero',
          belowMaxClass: 'is-below-max'
        }
      };

  function CharacterCounter($el, config) {
    CharacterCounter.baseConstructor.call(this, $el, config, defaultConfig);
    this.context = this.$el.attr('data-dough-character-counter-context');
    this.maxChars = this.$el.attr('data-dough-character-counter-max-chars') || 50;
  }

  DoughBaseComponent.extend(CharacterCounter);

  CharacterCounter.componentName = 'CharacterCounter';

  CharacterCounterProto = CharacterCounter.prototype;

  CharacterCounterProto.init = function(initialised) {
    this._cacheComponentElements();
    this._setupUIEvents();
    this.updateUI(this.getInputCharacterLength(), this.maxChars);
    this._initialisedSuccess(initialised);
  };

  CharacterCounterProto._cacheComponentElements = function() {
    this.$indicators = $(this.config.selectors.indicator + '[data-dough-character-counter-context="' + this.context + '"]');
    this.$warnings = $(this.config.selectors.warning + '[data-dough-character-counter-context="' + this.context + '"]');
  };

  CharacterCounterProto._setupUIEvents = function() {
    this.$el.on('input', $.proxy(this._handleInput, this));
  };

  CharacterCounterProto.calculateCharacterCount = function(count, maxChars) {
    return maxChars - count;
  };

  CharacterCounterProto.getInputCharacterLength = function() {
    return this.$el.val().length;
  };

  CharacterCounterProto.updateUI = function(count, maxChars) {
    var selectors = this.config.selectors,
        $uiIndicators = this.$warnings.add(this.$indicators);

    this.$indicators.text(this.calculateCharacterCount(count, maxChars));

    if(count < maxChars) {
      $uiIndicators
        .addClass(selectors.belowMaxClass)
        .removeClass(selectors.aboveMaxClass)
        .removeClass(selectors.zeroClass);
    }
    else if(count > maxChars) {
      $uiIndicators
        .addClass(selectors.aboveMaxClass)
        .removeClass(selectors.belowMaxClass)
        .removeClass(selectors.zeroClass);
    }
    else {
      $uiIndicators
        .addClass(selectors.zeroClass)
        .removeClass(selectors.aboveMaxClass)
        .removeClass(selectors.belowMaxClass);
    }
  };

  CharacterCounterProto._handleInput = function() {
    this.count = this.getInputCharacterLength();
    this.updateUI(this.count, this.maxChars);
  };

  return CharacterCounter;
});
