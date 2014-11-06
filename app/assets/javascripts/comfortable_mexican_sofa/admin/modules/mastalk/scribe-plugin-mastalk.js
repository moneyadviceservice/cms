define([
  'text!snippet-collapsible',
  'text!snippet-ticks',
  'text!snippet-callout',
  'text!snippet-add-action',
  'text!snippet-video',
  'text!snippet-action-item'
], function (
    collapsibleSnippet,
    ticksSnippet,
    calloutSnippet,
    addActionSnippet,
    videoSnippet,
    actionItemSnippet
  ) {
  'use strict';
  /**
   * This plugin adds each mastalk md snippet
   */
  return function (type) {
    return function (scribe) {
      var commandName = "mastalk_" + type;
      var mastalkCommand = new scribe.api.Command('insertHTML');

      mastalkCommand.execute = function () {
        scribe.insertPlainText(this.getType()[type].trim() + '\n\n');
      };

      mastalkCommand.getType = function () {
        return {
          actionItem: actionItemSnippet,
          addAction: addActionSnippet,
          collapsible: collapsibleSnippet,
          callout: calloutSnippet,
          ticks: ticksSnippet,
          video: videoSnippet
        };
      };

      mastalkCommand.queryState = function () {
        return true;
      };

      mastalkCommand.queryEnabled = function () {
        return true;
      };

      scribe.commands[commandName] = mastalkCommand;
    };
  };
});
