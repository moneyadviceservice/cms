define([
  'snippets-model'
], function (
    snippetsModel
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
        scribe.insertPlainText(snippetsModel.get(type).trim() + '\n\n');
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
