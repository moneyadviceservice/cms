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

  var LinkManagerProto,
      defaultConfig = {
        selectors: {
          context: '[data-dough-linkmanager-context]',
          insertLink: '[data-dough-linkmanager-insertlink]',
          valueTrigger: '[data-dough-linkmanager-value-trigger]',
          tabTrigger: '[data-dough-tab-selector-trigger]',
          linkInputs: '[data-dough-linkmanager-link-type]',
          currentLinkValue: '[data-dough-linkmanager-current-link-value]'
        },
        tabIds: {
          'external-page': 'external',
          'internal-page': 'internal',
          'external-file': 'external',
          'internal-file': 'file'
        }
      };

  function LinkManager($el, config) {
    LinkManager.baseConstructor.call(this, $el, config, defaultConfig);
    this.link = null;
    this.linkValues = {
      'internal': null,
      'file': null,
      'external': null
    };
  }

  DoughBaseComponent.extend(LinkManager);

  LinkManagerProto = LinkManager.prototype;

  LinkManagerProto.init = function(initialised) {
    this.context = this.$el.attr(this._stripSquareBrackets(this.config.selectors.context));
    this._cacheComponentElements();
    this._setupUIEvents();
    this._setupAppEvents();
    this._initialisedSuccess(initialised);
  };

  LinkManagerProto._cacheComponentElements = function() {
    this.$tabTriggers = this.$el.find(this.config.selectors.tabTrigger);
    this.$linkInputs = this.$el.find(this.config.selectors.linkInputs);
    this.$insertLinks = this.$el.find(this.config.selectors.insertLink);
    this.$valueTriggers = this.$el.find(this.config.selectors.valueTrigger);
  };

  LinkManagerProto._setupAppEvents = function() {
    eventsWithPromises.subscribe('cmseditor:link-published', $.proxy(this._handleShown, this));
    eventsWithPromises.subscribe('dialog:cancelled', $.proxy(this.close, this));
    eventsWithPromises.subscribe('dialog:closed', $.proxy(this.close, this));
  };

  LinkManagerProto._handleFormControlUpdate = function(e) {
    var $trigger = $(e.target),
        type = $trigger.attr(this._stripSquareBrackets(this.config.selectors.linkInputs));

    this.setLink(type, $trigger.val());
  };

  LinkManagerProto._handleShown = function(eventData) {
    if(!eventData || eventData.emitter !== this.$el.attr(this._stripSquareBrackets(this.config.selectors.context))) return false;

    if(eventData.link) {
      this._setup('existing', eventData.link);
    } else {
      this._setup('new');
    }
  };

  LinkManagerProto._handleInsertLink = function(e) {
    var link = this.getLink($(e.target).attr(this._stripSquareBrackets(this.config.selectors.insertLink)));
    this.publishLink(link);
    this.close();
  };

  LinkManagerProto._setup = function(type, link) {
    var linkType = this.config.tabIds[this._getLinkType(link)];

    if(type === 'new') {
      this.changeTab('internal');
    }
    else if(type === 'existing') {
      this.linkValues[linkType] = link;
      this.changeTab(linkType);
      this.setInputs(linkType, link);
    }
  };

  LinkManagerProto._setupUIEvents = function() {
    this.$el
      .on('input', '[data-dough-linkmanager-value-trigger][type="text"]', $.proxy(this._handleFormControlUpdate, this))
      .on('keyup', '[data-dough-linkmanager-value-trigger][type="text"]', $.proxy(this._handleFormControlUpdate, this))
      .on('change', '[data-dough-linkmanager-value-trigger][type="radio"]', $.proxy(this._handleFormControlUpdate, this))
      .on('click', '[data-dough-linkmanager-insertlink]', $.proxy(this._handleInsertLink, this));
  };

  LinkManagerProto._getLinkType = function(link) {
    // Note: Awaiting decision on full link formatting
    return 'external-file';
  };

  LinkManagerProto._stripSquareBrackets = function(str) {
    return str.replace(/([\[\]])+/gi,'');
  };

  LinkManagerProto.setLink = function(type, link) {
    if(!link || !type) return;
    this.linkValues[type] = link;
  };

  LinkManagerProto.getLink = function(type) {
    return this.linkValues[type];
  };

  LinkManagerProto.publishLink = function(link) {
    eventsWithPromises.publish('dialog:close', {
      emitter: this.context
    });

    eventsWithPromises.publish('linkmanager:link-published', {
      emitter: this.context,
      link: link
    });
  };

  LinkManagerProto.changeTab = function(id) {
    // Note: Ideally we would be calling the TabSelector methods directly
    // but currently Dough doesn't allow deferred components so we have
    // to click on the tab
    this.$tabTriggers.filter('[data-dough-tab-selector-trigger="' + id + '"]').click();
  };

  LinkManagerProto.close = function() {
    this.changeTab('internal');
    this.clearInputs();
  };

  LinkManagerProto.setInputs = function(type, link) {
    this.$linkInputs.filter('[data-dough-linkmanager-link-type="' + type + '"]').val(link);
  };

  LinkManagerProto.clearInputs = function() {
    this.$linkInputs.val('');
  };

  return LinkManager;
});
