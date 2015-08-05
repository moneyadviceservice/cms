define([
  'jquery',
  'DoughBaseComponent',
  'InsertManager',
  'eventsWithPromises',
  'filter-event',
  'URLFormatter'
], function (
  $,
  DoughBaseComponent,
  InsertManager,
  eventsWithPromises,
  filterEvent,
  URLFormatter
) {
  'use strict';

  var LinkManagerProto,
      defaultConfig = {
        selectors: {
        }
      };

  function LinkManager($el, config, customConfig) {
    LinkManager.baseConstructor.call(this, $el, config, customConfig || defaultConfig);
    this.open = false;
    this.itemValues = {
      'page': null,
      'file': null,
      'external': null
    };
  }

  DoughBaseComponent.extend(LinkManager, InsertManager);

  LinkManager.componentName = 'LinkManager';

  LinkManagerProto = LinkManager.prototype;

  LinkManagerProto.init = function(initialised) {
    LinkManager.superclass.init.call(this);
    this._initialisedSuccess(initialised);
  };

  LinkManagerProto._setup = function(type, val) {
    LinkManager.superclass._setup.call(this);
    this._populateAnchors(val);
  };

  LinkManagerProto._setupAppEvents = function() {
    eventsWithPromises.subscribe('cmseditor:insert-published', filterEvent($.proxy(this._handleShown, this), this.context));
    LinkManager.superclass._setupAppEvents.call(this);
  };

  LinkManagerProto._populateAnchors = function(selectedValue) {
    var self = this,
        html = '',
        id,
        text;

    this._resetSelectOptions(this.config.selectors.anchors);

    $(this.config.selectors.editorContents).find('h2, h3, h4').each(function() {
      text = $(this).html();
      id = self._slugify(text); // Use our function which mimics the Ruby kramdown function
      html += self._getAnchorOptionMarkup(self.config.selectors.anchors, '#' + id, text, selectedValue);
    });

    this.$insertInputs.filter(self.config.selectors.anchors).append(html);
  };

  LinkManagerProto._resetSelectOptions = function(selectSelector) {
    $(selectSelector).find('option[value]').remove();
  };

  LinkManagerProto._getAnchorOptionMarkup = function(selectSelector, value, text, selectedValue) {
    return '<option value="' + value + '"' + (value === selectedValue ? ' selected="selected"' : '') + '>' + text + '</option>';
  };

  LinkManagerProto._slugify = function(str) {
    return str.toString().toLowerCase()
      .replace(/\s+/g, '-')
      .replace(/[^\w\-]+/g, '');
  };

  return LinkManager;
});
