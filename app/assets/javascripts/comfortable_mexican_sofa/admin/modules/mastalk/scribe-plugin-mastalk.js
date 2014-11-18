define([
  'text!snippet-collapsible',
  'text!snippet-ticks',
  'text!snippet-callout',
  'text!snippet-add-action',
  'text!snippet-video',
  'text!snippet-action-item',
  'text!snippet-table'
], function (
    collapsibleSnippet,
    ticksSnippet,
    calloutSnippet,
    addActionSnippet,
    videoSnippet,
    actionItemSnippet,
    tableSnippet
  ) {
  'use strict';
  /**
   * This plugin adds each mastalk md snippet
   */
  return function (type) {
    return function (scribe) {
      var commandName = 'mastalk_' + type;
      var mastalkCommand = new scribe.api.Command('insertHTML');

      mastalkCommand.nodeName = 'P';

      mastalkCommand.execute = function () {
        scribe.insertPlainText(this.getType()[type].trim() + '\n\n');
      };

      mastalkCommand.getType = function () {
        return {
          actionItem: actionItemSnippet,
          addAction: addActionSnippet,
          collapsible: collapsibleSnippet,
          callout: calloutSnippet,
          table: tableSnippet,
          ticks: ticksSnippet,
          video: videoSnippet
        };
      };

      mastalkCommand.queryState = function () {
        return true;
      };

      mastalkCommand.queryEnabled = function () {
        var selection = new scribe.api.Selection();
        return (selection.selection.anchorNode === scribe.el) || !!selection.getContaining(function (node) {
          var innerText;
          if(node.innerText){
            innerText = node.innerText;
          }
          else {
            if(node !== document) {
              innerText = node.parentElement.innerText;
            }
          }
          return node.nodeName === this.nodeName && !innerText.replace('\n','').length;
        }.bind(this));
      };

      scribe.commands[commandName] = mastalkCommand;
    };
  };
});
