define(['jquery','DoughBaseComponent'], function ($, DoughBaseComponent) {
  'use strict';

  var SlugifierProto,
      defaultConfig = {
        uiEvents: {
          'keyup [data-dough-slugifier-input]': '_handleKeyUp'
        }
      };

  function Slugifier($el, config) {
    Slugifier.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(Slugifier);
  SlugifierProto = Slugifier.prototype;

  SlugifierProto.init = function(initialised) {
    this.$input =  this.$el.find('[data-dough-slugifier-input]');
    this.$slug = this.$el.find('[data-dough-slugifier-slug]');
    this._initialisedSuccess(initialised);
    return this;
  };

  SlugifierProto._handleKeyUp = function() {
    this.$slug.val(this.slugify(this.$input.val()));
  };

  SlugifierProto.slugify = function(str) {
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
    str = str.replace(charsToReplaceWithDelimiter, '-');
    charsToRemove = new RegExp('[^a-zA-Z0-9 -]', 'g');
    str = str.replace(charsToRemove, '').replace(/\s+/g, '-').toLowerCase();

    return str;
  };

  return Slugifier;
});
