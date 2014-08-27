define('mas-editor', [
  'editor',
  'editor-plugin-sticky-toolbar',
  'eventsWithPromises'
], function (
  Editor,
  editorPluginStickyToolbar,
  events
) {
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
      this.switchModeButtonNodes = this.options.switchModeButtonNodes;
      this.editor = new Editor(
        this.htmlEditorContentNode,
        this.markdownEditorContentNode,
        this.toolbarNode
      );
      this.editor.use(editorPluginStickyToolbar(this.toolbarNode));
      this.classActive = this.options.classActive || this.editor.constants.CLASSES.ACTIVE;
      this.mode = this.options.mode || this.editor.config.defaultEditingMode;

      this.bindEvents();
    },


    /**
     * Bind DOM events
     * @return {Object} this
     */
    bindEvents: function() {
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
     * Setups mode switching buttons
     * @return {Object} this
     */
    setupModeButton: function() {
      var i = this.switchModeButtonNodes.length,
          _this = this;

      while(i--) {
        (function(button) {
          button.addEventListener('click', function() {
            _this.handleModeButtonClick(button);
          });
        })(this.switchModeButtonNodes[i]);
      }
      return this;
    },

    /**
     * Handles Mode button click
     * @param  {Object} button Button DOM node
     * @return {[type]}        [description]
     */
    handleModeButtonClick: function(buttonNode) {
      var i = this.switchModeButtonNodes.length;

      while(i--) {
        this.switchModeButtonNodes[i].classList.remove(this.classActive);
      }
      buttonNode.classList.add(this.classActive);
      this.changeMode(buttonNode.dataset.mode);
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
