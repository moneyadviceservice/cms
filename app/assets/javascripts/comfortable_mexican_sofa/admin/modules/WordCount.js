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

  var WordCountProto,
      defaultConfig = {
        selectors: {
          hiddenClass: 'is-hidden',
          display: '[data-dough-wordcount-display]'
        }
      };

  function WordCount($el, config) {
    WordCount.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(WordCount);

  WordCountProto = WordCount.prototype;

  WordCount.componentName = 'WordCount';

  WordCountProto.init = function(initialised) {
    this._cacheComponentElements();
    this.$el.on('input keydown', $.proxy(this._handleInput, this));
    this.displayText = this.$display.attr('data-dough-wordcount-text');

    eventsWithPromises.subscribe('content:updated', $.proxy(function(mode) {
      this.updateDisplay(this.$el.text(), mode);
    }, this));

    this._initialisedSuccess(initialised);
  };

  WordCountProto._cacheComponentElements = function() {
    this.config.selectors.display = '[data-dough-wordcount-display="'+ this.$el.attr('data-dough-wordcount-target') +'"]';
    this.$display = $('body').find(this.config.selectors.display);
  };

  WordCountProto.updateDisplay = function(input, mode) {
    var classMethod = mode === 'markdown'? 'addClass' : 'removeClass';

    mode = mode || 'html';

    this.$display[classMethod](this.config.selectors.hiddenClass)
      .text(this.displayText.replace('{count}', this.countWords(input)));
  };

  WordCountProto.countWords = function(str) {
    var match = str.replace(/\n/gim,'').match(/\w+/gi);
    return match? match.length : 0;
  };

  WordCountProto._handleInput = function() {
    this.updateDisplay(this.$el.text());
  };

  return WordCount;
});
