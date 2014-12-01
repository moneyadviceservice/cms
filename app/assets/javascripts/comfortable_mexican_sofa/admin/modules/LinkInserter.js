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

  var LinkInserterProto,
      defaultConfig = {
        selectors: {
          context: '[data-dough-linkinserter-context]',
          insertLink: '[data-dough-linkinserter-insertlink]',
          valueTrigger: '[data-dough-linkinserter-value-trigger]',
          tabTrigger: '[data-dough-tab-selector-trigger]'
        },
        tabIds: {
          external: 'external',
          internal: 'internal',
          file: 'file'
        },
        uiEvents: {
          'click [data-dough-linkinserter-create]': 'insertLink'
        }
      };

  function LinkInserter($el, config) {
    LinkInserter.baseConstructor.call(this, $el, config, defaultConfig);
    this.link = null;
  }

  DoughBaseComponent.extend(LinkInserter);

  LinkInserterProto = LinkInserter.prototype;

  LinkInserterProto.init = function(initialised) {
    this._cacheComponentElements();
    this._setupAppEvents();
    this._setupUIEvents();
    this._initialisedSuccess(initialised);
  };

  LinkInserterProto._setupAppEvents = function() {
    eventsWithPromises.subscribe('dialog:shown', $.proxy(this._handleShown, this));
  };

  LinkInserterProto._cacheComponentElements = function() {
    this.$insertLinks = this.$el.find(this.config.selectors.insertLink);
    this.$valueTriggers = this.$el.find(this.config.selectors.valueTrigger);
    this.$tabTriggers = this.$el.find(this.config.selectors.tabTrigger);
  };

  LinkInserterProto._setupUIEvents = function() {

  };

  LinkInserterProto._handleShown = function(eventData) {
    if(!eventData || eventData.emitterId !== this.$el.attr(this._stripSquareBrackets(this.config.selectors.context))) return false;
    if(eventData.link) {
      this._setup('existing', eventData.link);
    } else {
      this._setup('new');
    }
  };

  LinkInserterProto._setup = function(type, link) {
    if(type === 'new') {
      this.changeTab(this.$tabTriggers, this.config.tabIds['internal']);
    }
    else if(type === 'existing') {
      this.link = link;
      this.changeTab(this.$tabTriggers, this.config.tabIds[this._checkLinkType(link)]);
    }
  };

  LinkInserterProto._checkLinkType = function(link) {
    return 'external';
  };

  LinkInserterProto._stripSquareBrackets = function(str) {
    return str.replace(/\[\]/i,'');
  };

  LinkInserterProto.changeTab = function($tabTriggers, id) {
    // Note: Ideally we would be calling the TabSelector methods directly
    // but currently Dough doesn't allow deferred components
    $tabTriggers.filter(id).click();
  };

  return LinkInserter;
});
