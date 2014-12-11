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

  var InsertManagerProto,
      defaultConfig = {
        selectors: {
          context: '[data-dough-insertmanager-context]',
          insertButton: '[data-dough-insertmanager-insert]',
          valueTrigger: '[data-dough-insertmanager-value-trigger]',
          tabTrigger: '[data-dough-tab-selector-trigger]',
          insertInputs: '[data-dough-insertmanager-insert-type]',
          currentItemLabel: '[data-dough-insertmanager-label]',
          loader: '[data-dough-insertmanager-loader]',
          url: '[data-dough-insertmanager-url]',
          activeClass: 'is-active',
          inactiveClass: 'is-inactive'
        }
      };

  function InsertManager($el, config) {
    InsertManager.baseConstructor.call(this, $el, config, defaultConfig);
    this.open = false;
    this.itemValues = {};
  }

  DoughBaseComponent.extend(InsertManager);

  InsertManagerProto = InsertManager.prototype;

  InsertManagerProto.init = function(initialised) {
    this.context = this.$el.attr(this._stripSquareBrackets(this.config.selectors.context));
    this.url = this.$el.attr(this._stripSquareBrackets(this.config.selectors.url));
    this._cacheComponentElements();
    this._setupUIEvents();
    this._setupAppEvents();
    this._initialisedSuccess(initialised);
  };

  InsertManagerProto._cacheComponentElements = function() {
    this.$tabTriggers = this.$el.find(this.config.selectors.tabTrigger);
    this.$insertInputs = this.$el.find(this.config.selectors.insertInputs);
    this.$currentItemLabels = this.$el.find(this.config.selectors.currentItemLabel);
    this.$insertButtons = this.$el.find(this.config.selectors.insertButton);
    this.$valueTriggers = this.$el.find(this.config.selectors.valueTrigger);
    this.$loader = this.$el.find(this.config.selectors.loader);
  };

  InsertManagerProto._setupAppEvents = function() {
    eventsWithPromises.subscribe('dialog:cancelled', $.proxy(this.close, this));
    eventsWithPromises.subscribe('dialog:closed', $.proxy(this.close, this));
  };

  InsertManagerProto._setupUIEvents = function() {
    this.$el
      .on('input', '[data-dough-insertmanager-value-trigger][type="text"]', $.proxy(this._handleFormControlUpdate, this))
      .on('keyup', '[data-dough-insertmanager-value-trigger][type="text"]', $.proxy(this._handleFormControlUpdate, this))
      .on('change', '[data-dough-insertmanager-value-trigger][type="radio"]', $.proxy(this._handleFormControlUpdate, this))
      .on('click', '[data-dough-insertmanager-insert]', $.proxy(this._handleInsertValue, this));
  };

  InsertManagerProto._handleFormControlUpdate = function(e) {
    var $trigger = $(e.target),
        type = $trigger.attr(this._stripSquareBrackets(this.config.selectors.insertInputs));

    this.setValue(type, $trigger.val());
  };

  InsertManagerProto._handleShown = function(eventData) {
    if(!eventData || eventData.emitter !== this.context) return false;
    if(eventData.val) {
      this._setup('existing', eventData.val);
    } else {
      this._setup('new');
    }
    this.open = true;
  };

  InsertManagerProto._handleInsertValue = function(e) {
    var type = $(e.target).attr(this._stripSquareBrackets(this.config.selectors.insertButton)),
        val = this.getValue(type);

    this.publishValue({
      val: val,
      type: type
    });
    this.close();
  };

  InsertManagerProto._handleAjaxLabelDone = function(data) {
    this.itemValues[data.type] = data.url;
    this.setInputs(data.type, data.url);
    this.setLabels(data.type, data.label);
    this.showLabels();
    this.changeTab(this.config.tabIds[data.type]);
    this.hideLoader();
  };

  InsertManagerProto._handleAjaxLabelFail = function() {
    this.hideLoader();
    this.changeTab(this.config.tabIds['default']);
  };

  InsertManagerProto._setup = function(type, val) {
    if(type === 'new') {
      this.changeTab('default');
    }
    else if(type === 'existing') {
      this.showLoader();
      this.getPageLabelPromise = this._getPageLabel(val);
      this.getPageLabelPromise
        .done($.proxy(this._handleAjaxLabelDone,this))
        .fail($.proxy(this._handleAjaxLabelFail,this));
    }
  };

  InsertManagerProto._getPageLabel = function(val) {
    var deferred = $.Deferred();
    $.ajax(this.url + '?id=' + val).done(function(data) {
      deferred.resolve(data);
    })
    .fail(function(data) {
      deferred.reject(data);
    });
    return deferred;
  };

  InsertManagerProto._stripSquareBrackets = function(str) {
    return str.replace(/([\[\]])+/gi,'');
  };

  InsertManagerProto.setValue = function(type, val) {
    if(!val || !type) return;
    this.itemValues[type] = val;
  };

  InsertManagerProto.getValue = function(type) {
    return this.itemValues[type];
  };

  InsertManagerProto.publishValue = function(eventData) {
    eventsWithPromises.publish('dialog:close', {
      emitter: this.context
    });

    $.extend(eventData || {}, {
      emitter: this.context
    });

    eventsWithPromises.publish('insertmanager:insert-published', eventData);
  };

  InsertManagerProto.changeTab = function(id) {
    // Note: Ideally we would be calling the TabSelector methods directly
    // but currently Dough doesn't allow deferred components so we have
    // to click on the tab
    this.$tabTriggers.filter('[data-dough-tab-selector-trigger="' + id + '"]').click();
  };

  InsertManagerProto.showLoader = function() {
    this.$loader
      .addClass(this.config.selectors.activeClass)
      .removeClass(this.config.selectors.inactiveClass);
  };

  InsertManagerProto.hideLoader = function() {
    this.$loader
      .removeClass(this.config.selectors.activeClass)
      .addClass(this.config.selectors.inactiveClass);
  };

  InsertManagerProto.close = function() {
    if(!this.open) return false;
    this.changeTab('default');
    this.getPageLabelPromise && this.getPageLabelPromise.reject();
    this.clearInputs();
    this.open = false;
  };

  InsertManagerProto.setInputs = function(type, val) {
    this.$insertInputs.filter('[data-dough-insertmanager-insert-type="' + type + '"]').val(val);
  };

  InsertManagerProto.clearInputs = function() {
    this.$insertInputs.val('');
  };

  InsertManagerProto.setLabels = function(type, val) {
    this.$currentItemLabels.filter('[data-dough-insertmanager-label="' + type + '"]').text(val);
  };

  InsertManagerProto.showLabels = function() {
    this.$currentItemLabels
      .addClass(this.config.selectors.activeClass)
      .removeClass(this.config.selectors.inactiveClass);
  };

  InsertManagerProto.hideLabels = function() {
    this.$currentItemLabels
      .removeClass(this.config.selectors.activeClass)
      .addClass(this.config.selectors.inactiveClass);
  };

  return InsertManager;
});
