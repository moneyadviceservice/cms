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

  var LinkEditorProto,
      defaultConfig = {
        selectors: {
          context: '[data-dough-linkinserter-context]'
        },
        tabIds: {
          'external-page': 'external',
          'internal-page': 'internal',
          'external-file': 'file',
          'internal-file': 'file'
        }
      };

  function LinkEditor($el, config) {
    LinkEditor.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(LinkEditor);

  LinkEditorProto = LinkEditor.prototype;

  LinkEditorProto.init = function(initialised) {
    this._initialisedSuccess(initialised);
  };

  LinkEditorProto._cacheComponentElements = function() {

  };

  LinkEditorProto._handleShown = function(eventData) {
    if(!eventData || eventData.emitter !== this.$el.attr(this._stripSquareBrackets(this.config.selectors.context))) return false;
    if(eventData.link) {
      this._setup('existing', eventData.link);
    } else {
      this._setup('new');
    }
  };

  LinkEditorProto._setup = function(type, link) {
    if(type === 'new') {
      this.changeTab(this.$tabTriggers, this.config.tabIds['internal']);
    }
    else if(type === 'existing') {
      this.link = link;
      this.changeTab(this.$tabTriggers, this.config.tabIds[this._getLinkType(link)]);
    }
  };

  LinkEditorProto._getLinkType = function(link) {
    // Note: Awaiting decision on full link formatting
    return 'external';
  };

  LinkEditorProto._stripSquareBrackets = function(str) {
    return str.replace(/([\[\]])+/gi,'');
  };

  LinkEditorProto.changeTab = function($tabTriggers, id) {
    // Note: Ideally we would be calling the TabSelector methods directly
    // but currently Dough doesn't allow deferred components
    $tabTriggers.filter(id).click();
  };

  return LinkEditor;
});
