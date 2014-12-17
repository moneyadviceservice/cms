define('scribe-plugin-linkeditor', [
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
          linkEditorCommand = new scribe.api.Command('createLink'),
          externalLinkSuffix = '{:target="_blank"}',
          externalLinkSuffixRegEx = /\{\:target\=\"\_blank\"\}/i;

      linkEditorCommand.nodeName = 'A';

      linkEditorCommand.execute = function () {
        var node = this.getMatchingNode();

        this.saveSelection();

        eventsWithPromises.publish('cmseditor:insert-published', {
          emitter: context,
          val: !!node? node.attributes['href'].value : null
        });
      };

      linkEditorCommand.inject = function(link) {
        var selection = new scribe.api.Selection(),
            range = selection.range,
            anchorNode;

        anchorNode = selection.getContaining(function (node) {
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
        return !! this.getMatchingNode();
      };

      linkEditorCommand.getMatchingNode = function() {
        var selection = new scribe.api.Selection();
        return selection.getContaining(function (node) {
          return node.nodeName === this.nodeName;
        }.bind(this));
      };

      linkEditorCommand.queryEnabled = function() {
        return true;
      };

      linkEditorCommand.haslinkSuffix = function(referenceNode, suffix, suffixRegEx) {
        if(referenceNode && referenceNode.nodeType === 3) {
          return suffixRegEx.test(referenceNode.substringData(0, suffix.length));
        }
      };

      linkEditorCommand.insertLinkSuffix = function(referenceNode, suffix) {
        referenceNode.parentNode.insertBefore(document.createTextNode(suffix), referenceNode);
      };

      linkEditorCommand.removeLinkSuffix = function(referenceNode, suffixRegEx) {
        if(referenceNode.nodeType === 3) {
          var match = suffixRegEx.exec(referenceNode.textContent);
          referenceNode.textContent = referenceNode.textContent.replace(match, '');
        }
      };

      linkEditorCommand.formatLink = function(type) {
        var range = rangy.getSelection(),
            node = range.getRangeAt(0).commonAncestorContainer,
            haslinkSuffix = this.haslinkSuffix(node.nextSibling, externalLinkSuffix, externalLinkSuffixRegEx);

        type = type || 'page';

        if(type === 'external' && !haslinkSuffix) {
          this.insertLinkSuffix(node.nextSibling, externalLinkSuffix);
        }
        else if(type !== 'external'){
          this.removeLinkSuffix(node.nextSibling, externalLinkSuffixRegEx);
        }
      };

      linkEditorCommand.handleLinkPublished = function(eventData) {
        this.inject(eventData.val);
        this.formatLink(eventData.type);
      };

      linkEditorCommand.saveSelection = function() {
        savedSelection = rangy.saveSelection(document);
      };

      linkEditorCommand.removeSelection = function() {
        rangy.restoreSelection(savedSelection, false);
        rangy.removeMarkers(savedSelection);
      };

      linkEditorCommand.setupEvents = function() {
        eventsWithPromises.subscribe('dialog:closed', filterEvent(this.removeSelection.bind(this), context));
        eventsWithPromises.subscribe('dialog:cancelled', filterEvent(this.removeSelection.bind(this), context));
        eventsWithPromises.subscribe('insertmanager:insert-published', filterEvent(linkEditorCommand.handleLinkPublished.bind(this), context));
      };

      linkEditorCommand.init = function() {
        this.setupEvents();
      };

      linkEditorCommand.init();

      scribe.commands.editLink = linkEditorCommand;
    };
  };

});
