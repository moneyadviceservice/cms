define('scribe-plugin-linkeditor', [
  'eventsWithPromises'
],
function (eventsWithPromises) {
  /**
   * This plugin adds a command for editing/creating links via LinkEditor/LinkInserter
   */
  return function () {
    return function (scribe) {
      var handleLinkPublished,
          linkEditorCommand = new scribe.api.Command('createLink');

      linkEditorCommand.nodeName = 'A';

      linkEditorCommand.execute = function (link) {
        var selection = this.selection || new scribe.api.Selection();
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
        this.selection = new scribe.api.Selection();
        return !! this.selection.getContaining(function (node) {
          return node.nodeName === this.nodeName;
        }.bind(this));
      };

      linkEditorCommand.queryEnabled = function() {
        return true;
      };

      handleLinkPublished = function(eventData, promise) {
        if(eventData.emitter === 'add-link') {
          linkEditorCommand.execute.call(linkEditorCommand, eventData.link);
          promise.resolve();
        }
      };

      eventsWithPromises.subscribe('linkmanager:link-published', handleLinkPublished);

      scribe.commands.linkEditor = linkEditorCommand;
    };
  };

});
