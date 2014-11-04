define('scribe-plugin-mastalk',[],function () {
  'use strict';
  require([
    'text',
    'text!/assets/comfortable_mexican_sofa/admin/modules/mastalk/snippets/collapsible.md'
  ], function(text, collapsibleSnippet) {
    /**
     * This plugin adds each mastalk md snippet
     */

    return function (type) {
      return function (scribe) {
        var commandName = "mastalk_" + type;

        var mastalkCommand = new scribe.api.Command('formatBlock');

        mastalkCommand.execute = function () {
          getType()[type].split("\n").map(function (l) {
            scribe.insertPlainText(l.trim() + "\n\n");
          });
        };

        var getType = function () {
          return {
            collapsible: collapsibleSnippet,
            ticks: ticks()
          }
        };

        var ticks = function() {
          return "$yes-no \n\
            [y] yes \n\
            [n] no \n\
           $end \n"
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
});
