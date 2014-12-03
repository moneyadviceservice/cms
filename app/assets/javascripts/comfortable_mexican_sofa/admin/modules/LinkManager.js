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
          tabTrigger: '[data-dough-linkmanager-tabtrigger]',
          linkInputs: '[data-dough-linkmanager-link-type]'
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
    this.context = this.$el.attr(this._stripSquareBrackets(this.config.selectors.context));
  }

  DoughBaseComponent.extend(LinkManager);

  LinkManagerProto = LinkManager.prototype;

  LinkManagerProto.init = function(initialised) {
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
    eventsWithPromises.subscribe('dialog:shown', $.proxy(this._handleShown, this));
  };

  LinkManagerProto._handleFormControlUpdate = function(e) {
    this.setLink($(e.target).val());
  };

  LinkManagerProto._handleShown = function(eventData) {
    if(!eventData || eventData.emitter !== this.$el.attr(this._stripSquareBrackets(this.config.selectors.context))) return false;

    if(eventData.link) {
      this._setup('existing', eventData.link);
    } else {
      this._setup('new');
    }
  };

  LinkManagerProto._setup = function(type, link) {
    if(type === 'new') {
      this.changeTab(this.$tabTriggers, this.config.tabIds['internal']);
    }
    else if(type === 'existing') {
      this.link = link;
      this.changeTab(this.$tabTriggers, this.config.tabIds[this._getLinkType(link)]);
    }
  };

  LinkManagerProto._setupUIEvents = function() {
    this.$el
      .on('input', '[data-dough-linkmanager-value-trigger][type="text"]', $.proxy(this._handleFormControlUpdate, this))
      .on('keyup', '[data-dough-linkmanager-value-trigger][type="text"]', $.proxy(this._handleFormControlUpdate, this))
      .on('change', '[data-dough-linkmanager-value-trigger][type="radio"]', $.proxy(this._handleFormControlUpdate, this))
      .on('click', '[data-dough-linkmanager-insertlink]', $.proxy(this.publishLink, this));
  };

  LinkManagerProto.setLink = function(link) {
    if(!link) return;
    this.link = link;
  };

  LinkManagerProto.getLink = function() {
    return this.link;
  };

  LinkManagerProto.publishLink = function() {
    // Note: Let's move this out of here at some point.
    eventsWithPromises.publish('dialog:close', {
      emitter: this.context
    });

    eventsWithPromises.publish('linkmanager:link-published', {
      emitter: this.context,
      link: this.link
    });
  };

  LinkManagerProto._getLinkType = function(link) {
    // Note: Awaiting decision on full link formatting
    return 'external-file';
  };

  LinkManagerProto._stripSquareBrackets = function(str) {
    return str.replace(/([\[\]])+/gi,'');
  };

  LinkManagerProto.changeTab = function($tabTriggers, id) {
    // Note: Ideally we would be calling the TabSelector methods directly
    // but currently Dough doesn't allow deferred components so we have
    // to click on the tab
    $tabTriggers.filter('[data-dough-linkmanager-tabtrigger="' + id + '"]').click();

    // Call function to update the content
  };

  LinkManagerProto.setInputs = function(type, link) {
    this.$linkInputs.filter('[data-dough-linkmanager-link-type="' + type + '"]').val(link);
  };

  return LinkManager;
});
