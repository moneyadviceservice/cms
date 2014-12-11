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

      insertImageCommand.nodeName = 'IMG';

      insertImageCommand.execute = function (url) {
        scribe.api.SimpleCommand.prototype.execute.call(this, '<img src="'+ url +'">');
      };

      insertImageCommand.queryState = function () {
        return false;
      };

      insertImageCommand.queryEnabled = function() {
        return true;
      };

      insertImageCommand.handleInsertPublished = function(eventData) {
        if(!eventData.url) return;
        this.insert(eventData.url);
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
