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
  }

  DoughBaseComponent.extend(CharacterCounter);

  CharacterCounterProto = CharacterCounter.prototype;

  CharacterCounterProto.init = function(initialised) {
    this.context = this.$el.attr('data-dough-character-counter-context');
    this.maxChars = this.$el.attr('data-dough-character-counter-max-chars');
    this._cacheComponentElements();
    this._setupUIEvents();
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

  CharacterCounterProto.getCharacterLength = function(str) {
    return str.length;
  };

  CharacterCounterProto.updateUI = function(count, maxChars) {
    var selectors = this.config.selectors,
        $uiIndicators = this.$warnings.add(this.$indicators);

    this.$indicators.text(this.calculateCharacterCount(count, maxChars));

    if(count < maxChars) {
      $uiIndicators
        .addClass(selectors.belowMaxClass)
        .removeClass(selectors.aboveMaxClass);
    }
    else if(count > maxChars) {
      $uiIndicators
        .addClass(selectors.aboveMaxClass)
        .removeClass(selectors.belowMaxClass);
    }
    else {
      $uiIndicators
        .addClass(selectors.zeroClass)
        .removeClass([selectors.aboveMaxClass,selectors.belowMaxClass].join(','));
    }
  };

  CharacterCounterProto._handleInput = function(e) {
    this.count = this.getCharacterLength(e.currentTarget.value);
    this.updateUI();
  };

  return CharacterCounter;
});
