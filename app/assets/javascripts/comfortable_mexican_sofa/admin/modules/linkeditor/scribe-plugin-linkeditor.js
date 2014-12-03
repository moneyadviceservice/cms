define('scribe-plugin-linkeditor', [
  'eventsWithPromises',
  'rangy-core',
  'rangy-selectionsaverestore'
],
function (eventsWithPromises, rangy, rangySelectionSaveRestore) {

  /**
   * This plugin adds a command for editing/creating links via LinkEditor/LinkInserter
   */
  return function () {
    return function (scribe) {
      var savedSelection,
          linkManagerContext = 'add-link',
          linkEditorCommand = new scribe.api.Command('createLink');

      linkEditorCommand.nodeName = 'A';

      linkEditorCommand.execute = function () {
        this.saveSelection();
      };

      linkEditorCommand.inject = function(link) {
        var selection = new scribe.api.Selection();
        var range = selection.range;
        var anchorNode = selection.getContaining(function (node) {
          return node.nodeName === this.nodeName;
        }.bind(this));

        if (anchorNode) {
          range.selectNode(anchorNode);
          selection.selection.removeAllRanges();
          selection.selection.addRange(range);
        }

        scribe.api.SimpleCommand.prototype.execute.call(this, link);
      };

      linkEditorCommand.queryState = function () {
        var selection = new scribe.api.Selection();
        return !! selection.getContaining(function (node) {
          return node.nodeName === this.nodeName;
        }.bind(this));
      };

      linkEditorCommand.queryEnabled = function() {
        return true;
      };

      linkEditorCommand.handleLinkPublished = function(eventData, promise) {
        if(eventData.emitter === linkManagerContext) {
          linkEditorCommand.inject.call(linkEditorCommand, eventData.link);
          promise.resolve();
        }
      };

      linkEditorCommand.saveSelection = function() {
        savedSelection = rangy.saveSelection(document);
      };

      linkEditorCommand.removeSelection = function() {
        rangy.restoreSelection(savedSelection, false);
        rangy.removeMarkers(savedSelection);
      };

      linkEditorCommand.setupEvents = function() {
        eventsWithPromises.subscribe('dialog:closed', function() {
          this.removeSelection();
        }.bind(this));

        eventsWithPromises.subscribe('dialog:cancelled', function() {
          this.removeSelection();
        }.bind(this));
      };

      linkEditorCommand.init = function() {
        this.setupEvents();
      };

      linkEditorCommand.init();

      eventsWithPromises.subscribe('linkmanager:link-published', linkEditorCommand.handleLinkPublished.bind(this));

      scribe.commands.editLink = linkEditorCommand;
    };
  };

});
