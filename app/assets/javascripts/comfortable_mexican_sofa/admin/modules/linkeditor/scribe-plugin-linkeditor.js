define('scribe-plugin-linkeditor', [
  'eventsWithPromises',
  'rangy-core',
  'rangy-selectionsaverestore'
],
function (eventsWithPromises, rangy, rangySelectionSaveRestore) {
  'use strict';

  /**
   * This plugin adds a command for editing/creating links via LinkEditor/LinkInserter
   */
  return function () {
    return function (scribe) {
      var savedSelection,
          linkManagerContext = 'add-link',
          linkEditorCommand = new scribe.api.Command('createLink'),
          externalLinkSuffix = '{:target="_blank"}',
          externalLinkSuffixRegEx = /\{\:target\=\"\_blank\"\}/i;

      linkEditorCommand.nodeName = 'A';

      linkEditorCommand.execute = function () {
        var node = this.getMatchingNode();

        this.saveSelection();

        eventsWithPromises.publish('cmseditor:link-published', {
          emitter: linkManagerContext,
          link: !!node? node.attributes['href'].value : null
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

      linkEditorCommand.getLinkSuffix = function(referenceNode, suffix, suffixRegEx) {
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
            haslinkSuffix = this.getLinkSuffix(node.nextSibling, externalLinkSuffix, externalLinkSuffixRegEx);

        type = type || 'page';

        if(type === 'external' && !haslinkSuffix) {
          this.insertLinkSuffix(node.nextSibling, externalLinkSuffix);
        }
        else if(type !== 'external'){
          this.removeLinkSuffix(node.nextSibling, externalLinkSuffixRegEx);
        }
      };

      linkEditorCommand.handleLinkPublished = function(eventData, promise) {
        if(eventData && eventData.link && eventData.emitter === linkManagerContext) {
          linkEditorCommand.inject.call(linkEditorCommand, eventData.link);
          linkEditorCommand.formatLink(eventData.type);
          promise.resolve();
        }
        else {
          promise.reject();
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
        eventsWithPromises.subscribe('dialog:closed', this.removeSelection.bind(this));
        eventsWithPromises.subscribe('dialog:cancelled', this.removeSelection.bind(this));
        eventsWithPromises.subscribe('linkmanager:link-published', linkEditorCommand.handleLinkPublished.bind(this));
      };

      linkEditorCommand.init = function() {
        this.setupEvents();
      };

      linkEditorCommand.init();

      scribe.commands.editLink = linkEditorCommand;
    };
  };

});
