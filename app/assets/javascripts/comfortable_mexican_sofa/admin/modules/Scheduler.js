define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var SchedulerProto,
      defaultConfig = {
        selectors: {
          scheduleButton: '[data-dough-dialog-trigger=scheduler]',
          formToSubmit: '[data-dough-scheduler-form]',
          scheduleTrigger: '[data-dough-scheduler-trigger]',
          scheduledDate: '[data-dough-scheduler-date]',
          scheduledTime: '[data-dough-scheduler-time]',
          scheduledOn: '[data-dough-scheduler-on]'
        }
      };

  function Scheduler($el, config) {
    Scheduler.baseConstructor.call(this, $el, config, defaultConfig);
  };

  DoughBaseComponent.extend(Scheduler);

  SchedulerProto = Scheduler.prototype;

  SchedulerProto.init = function(initialised) {
    this._cacheComponentElements();
    this._setupUIEvents();
    this._initialisedSuccess(initialised);
  };

  SchedulerProto._cacheComponentElements = function() {
    this.$scheduleButton  = $(this.config.selectors.scheduleButton);
    this.$formToSubmit    = $(this.config.selectors.formToSubmit);
    this.$scheduledDate   = $(this.config.selectors.scheduledDate);
    this.$scheduledTime   = $(this.config.selectors.scheduledTime);
    this.$scheduledOn     = $(this.config.selectors.scheduledOn);
    this.$scheduleTrigger = $(this.config.selectors.scheduleTrigger);
  };

  SchedulerProto._setupUIEvents = function() {
    this.$scheduleButton.on('click', $.proxy(this._preventFormSubmission, this));
    this.$scheduleTrigger.on('click', $.proxy(this._handleFormSubmit, this));
  };

  SchedulerProto._preventFormSubmission = function(e) {
    e.preventDefault();
  };

  SchedulerProto._handleFormSubmit = function(e) {
    this.$scheduledOn.val(this.$scheduledDate.val() + "T" + this.$scheduledTime.val());
    this.$formToSubmit.append($("<input>").attr("type", "hidden").attr("name", "state_event").val("schedule"));
    this.$formToSubmit.submit();
  };

  return Scheduler;
});
