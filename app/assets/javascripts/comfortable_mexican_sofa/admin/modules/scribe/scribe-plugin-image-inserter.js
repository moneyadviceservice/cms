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
      var savedSelection,
          insertImageCommand = new scribe.api.Command('insertHTML');

      insertImageCommand.nodeName = 'P';
      insertImageCommand.validNodes = ['P','LI','A'];

      insertImageCommand.execute = function () {
        this.saveSelection();
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

      insertImageCommand.insert = function (imageCode) {
        scribe.api.SimpleCommand.prototype.execute.call(this, imageCode);
      };

      insertImageCommand.handleInsertPublished = function(eventData) {
        if(!eventData.val) return;
        this.insert(eventData.val);
      };

      insertImageCommand.saveSelection = function() {
        savedSelection = rangy.saveSelection(document);
      };

      insertImageCommand.removeSelection = function() {
        rangy.restoreSelection(savedSelection, false);
        rangy.removeMarkers(savedSelection);
      };

      insertImageCommand.setupEvents = function() {
        eventsWithPromises.subscribe('dialog:closed', filterEvent(this.removeSelection.bind(this), context));
        eventsWithPromises.subscribe('dialog:cancelled', filterEvent(this.removeSelection.bind(this), context));
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
