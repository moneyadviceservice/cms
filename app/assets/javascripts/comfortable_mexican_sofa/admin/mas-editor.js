define('mas-editor', [
  'editor'
], function (
  Editor
) {
  'use strict';
  return {
    /**
     * Setups options and instantiates Editor instance
     * @param  {Object} options Options
     * @return {Object} this
     */
    init: function(options) {
      if(typeof options !== 'object') return;

      this.options = options;
      this.cmsFormNode = this.options.cmsFormNode;
      this.toolbarNode = this.options.toolbarNode;
      this.editorContainer = this.options.editorContainer;
      this.htmlEditorNode = this.options.htmlEditorNode;
      this.htmlEditorContentNode = this.options.htmlEditorContentNode;
      this.markdownEditorNode = this.options.markdownEditorNode;
      this.markdownEditorContentNode = this.options.markdownEditorContentNode;
      this.switchModeTriggerNodes = this.options.switchModeTriggerNodes;
      this.editor = new Editor(
        this.htmlEditorContentNode,
        this.markdownEditorContentNode,
        this.toolbarNode
      );
      this.classActive = this.options.classActive || this.editor.constants.CLASSES.ACTIVE;
      this.mode = this.options.mode || this.editor.config.defaultEditingMode;

      this.addUIEvents();
      this.setupAppEvents();
      this.setupToolbar();
    },


    /**
     * Bind DOM events
     * @return {Object} this
     */
    addUIEvents: function() {
      var _this = this;

      // Catches form submit and delegates to a handler function
      this.cmsFormNode.addEventListener('submit', function(event) {
        event.preventDefault();
        _this.handleSubmit();
      });

      this.setupModeButton();

      return this;
    },

    /**
     * [setupAppEvents description]
     * @return {[type]} [description]
     */
    setupAppEvents: function() {
      this.editor.events.subscribe('mode:changed', this.handleChangeModeEvent, this);
      return this;
    },

    /**
     * Setups mode switching buttons
     * @return {Object} this
     */
    setupModeButton: function() {
      var i = this.switchModeTriggerNodes.length,
          _this = this;

      while(i--) {
        (function(node) {
          node.addEventListener('click', function() {
            _this.changeMode(node.value);
          });
        })(this.switchModeTriggerNodes[i]);
      }
      return this;
    },

    /**
     * [setupToolbar description]
     * @return {[type]} [description]
     */
    setupToolbar: function() {
      this.toolbarNode.classList.add(this.classActive);
      return this;
    },

    /**
     * Handles Mode button click
     * @param  {Object} button Button DOM node
     * @return {[type]}        [description]
     */
    handleChangeModeEvent: function(mode) {
      Array.prototype.map.call(this.switchModeTriggerNodes, function(node) {
        node.classList.remove(this.classActive);
        if(node.dataset.mode === mode) {
          node.classList.add(this.classActive);
        }
      }.bind(this));
    },


    /**
     * Converts HTML input into Markdown then submits form
     * @return {Object} this
     */
    handleSubmit: function() {
      if(this.mode === this.editor.constants.MODES.HTML) {
        this.editor.changeEditingMode(this.editor.constants.MODES.MARKDOWN);
      }
      this.cmsFormNode.submit();
      return this;
    },

    /**
     * Handles switch between HTML and Markdown mode
     * @param  {String} mode html|markdown
     * @return {Object} this
     */
    changeMode: function(mode) {
      if(mode === this.mode) return;

      this.mode = mode;

      switch(mode) {
        case this.editor.constants.MODES.HTML:
          this.show(this.htmlEditorNode).hide(this.markdownEditorNode);
          break;
        case this.editor.constants.MODES.MARKDOWN:
          this.show(this.markdownEditorNode).hide(this.htmlEditorNode);
          break;
        default:
          this.show(this.htmlEditorNode).hide(this.markdownEditorNode);
          break;
      }

      this.editor.changeEditingMode(this.mode);

      return this;
    },

    /**
     * Adds an active class to a DOM node
     * @param  {Object} node Target DOM node
     * @return {Object} this
     */
    show: function(node) {
      node.classList.add(this.classActive);
      return this;
    },

    /**
     * Removes active class from a DOM node
     * @param  {Object} node Target DOM node
     * @return {Object} this
     */
    hide: function(node) {
      node.classList.remove(this.classActive);
      return this;
    }
  };
});
