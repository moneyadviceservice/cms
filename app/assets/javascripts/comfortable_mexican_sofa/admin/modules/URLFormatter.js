define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var URLFormatterProto,
      defaultConfig = {
        selectors: {
          pageType: '[data-dough-urlformatter-page-type]',
          slugInput: '[data-dough-urlformatter-slug]',
          input: '[data-dough-urlformatter-input="true"]',
          urlDisplay: '[data-dough-urlformatter-url-display]'
        }
      };

  function URLFormatter($el, config) {
    URLFormatter.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(URLFormatter);

  URLFormatter.componentName = 'URLFormatter';

  URLFormatterProto = URLFormatter.prototype;

  URLFormatterProto.init = function(initialised) {
    this.baseUrl = this.$el.attr('data-dough-urlformatter-base-url');
    this._cacheComponentElements();
    this._setupUIEvents();
    this._initialisedSuccess(initialised);
  };

  URLFormatterProto._cacheComponentElements = function() {
    this.$titleInput = this.$el.find(this.config.selectors.input);
    this.$pageType = this.$el.find(this.config.selectors.pageType);
    this.$slugInput = this.$el.find(this.config.selectors.slugInput);
    this.slugInput = this.$slugInput[0];
    this.$urlDisplays = this.$el.find(this.config.selectors.urlDisplay);
  };

  URLFormatterProto._setupUIEvents = function() {
    this.$titleInput.on('input', $.proxy(this._handleTitleInput, this));
    this.$pageType.on('change', $.proxy(this._handleInput, this));
    this.$slugInput.on('input', $.proxy(this._handleSlugInput, this));
  };

  URLFormatterProto.buildUrl = function(baseUrl, data) {
    return baseUrl.replace(/{([^{}]*)}/g,
      function (a, b) {
        return data[b];
      }
    );
  };

  URLFormatterProto.updateDisplay = function(userInput) {
    this.$urlDisplays.text(userInput);
  };

  URLFormatterProto.getUserInput = function() {
    return {
      pageType: this.$pageType.find('option:selected').attr('data-dough-urlformatter-page-type-value'),
      slug: this.$slugInput.val()
    };
  };

  URLFormatterProto._unbindInputEvent = function() {
    this.$titleInput.off('input', this._handleTitleInput);
  };

  URLFormatterProto._handleTitleInput = function () {
    this.slugifySlugInput(this.$titleInput.val());
    this._handleInput();
  };

  URLFormatterProto._handleInput = function() {
    this.updateDisplay(this.buildUrl(this.baseUrl, this.getUserInput()));
  };

  URLFormatterProto._handleSlugInput = function() {
    var caretPos = this.getCaretPos(this.slugInput);
    this.slugifySlugInput(this.$slugInput.val());
    this._handleInput();
    this.setCaretPos(this.slugInput, caretPos, caretPos);
    this._unbindInputEvent();
  };

  URLFormatterProto.getCaretPos = function(field) {
    return field.selectionDirection === 'backward' ? field.selectionStart : field.selectionEnd;
  };

  URLFormatterProto.setCaretPos = function(field, start, end) {
    field.focus();
    field.setSelectionRange(start, end);
  };

  URLFormatterProto.slugifySlugInput = function(str) {
    this.$slugInput.val(this.slugify(str));
  };

  URLFormatterProto.slugify = function(str) {
    // slugify method taken from Comfy
    var i,
        from,
        to,
        charsToRemove,
        charsToReplaceWithDelimiter;

    str = str.replace(/^\s+|\s+$/g, '');

    from = 'ÀÁÄÂÃÈÉËÊÌÍÏÎÒÓÖÔÕÙÚÜÛàáäâãèéëêìíïîòóöôõùúüûÑñÇç';
    to = 'aaaaaeeeeiiiiooooouuuuaaaaaeeeeiiiiooooouuuunncc';

    for(i = 0; i < [from.length - 1];i++) {
      str = str.replace(new RegExp(from[i], 'g'), to[i]);
    }

    charsToReplaceWithDelimiter = new RegExp('[·/,:;_]', 'g');
    charsToRemove = new RegExp('[^a-zA-Z0-9 -]', 'g');

    str = str.replace(charsToReplaceWithDelimiter, '-');
    str = str.replace(charsToRemove, '').replace(/\s+/g, '-').toLowerCase();

    return str;
  };

  return URLFormatter;
});
