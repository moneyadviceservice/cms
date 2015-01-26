define('scribe-plugin-image-inserter', [
  'eventsWithPromises',
  'rangy-core',
  'rangy-selectionsaverestore',
  'filter-event'
],
function (eventsWithPromises, rangy, rangySelectionSaveRestore, filterEvent) {
  'use strict';

  /**
   * This plugin adds a command for editing/creating links via LinkEditor/LinkInserter
   */
  return function (context) {
    return function (scribe) {
      var insertImageCommand = new scribe.api.Command('insertHTML');

      insertImageCommand.nodeName = 'P';
      insertImageCommand.validNodes = ['P','LI','A'];

      insertImageCommand.execute = function () {
        return true;
      };

      insertImageCommand.queryState = function () {
        return false;
      };

      insertImageCommand.queryEnabled = function() {
        var selection = new scribe.api.Selection();
        return selection.getContaining(function (node) {
          return insertImageCommand.validNodes.indexOf(node.nodeName) !== -1;
        });
      };

      insertImageCommand.insert = function (url) {
        scribe.api.SimpleCommand.prototype.execute.call(this, '<img src="'+ url +'">');
      };

      insertImageCommand.handleInsertPublished = function(eventData) {
        if(!eventData.val) return;
        this.insert(eventData.val);
      };

      insertImageCommand.setupEvents = function() {
        eventsWithPromises.subscribe('insertmanager:insert-published',
          filterEvent(this.handleInsertPublished.bind(this), context)
        );
      };

      insertImageCommand.init = function() {
        this.setupEvents();
      };

      insertImageCommand.init();

      scribe.commands.insertImage = insertImageCommand;
    };
  };

});
