define('mas-editor', [
  'editor',
  'editor-plugin-sticky-toolbar'
], function (
  Editor,
  editorPluginStickyToolbar
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
      this.mode = this.options.mode || 'html';
      this.classActive = 'is-active';
      this.cmsFormNode = this.options.cmsFormNode;
      this.toolbarNode = this.options.toolbarNode;
      this.htmlEditorNode = this.options.htmlEditorNode;
      this.htmlEditorContentNode = this.options.htmlEditorContentNode;
      this.markdownEditorNode = this.options.markdownEditorNode;

      this.editor = new Editor(
        this.htmlEditorContentNode,
        this.markdownEditorNode,
        this.toolbarNode
      );
      this.editor.use(editorPluginStickyToolbar(this.toolbarNode));
      this.editor.render(this.mode);

      this.appendHTMLEditorNode(this.htmlEditorNode, this.markdownEditorNode);

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
      var buttonNodes = document.querySelectorAll('.js-switch-mode'),
          i = buttonNodes.length,
          _this = this;

      while(i--) {
        (function(button) {
          button.addEventListener('click', function() {
            _this.changeMode(button.dataset.mode);
          });
        })(buttonNodes[i]);
      }
      return this;
    },

    /**
     * Appends one DOM node to another
     * Used to move the HTML editor node into the same parent as Markdown editor
     * @param  {Object} options Options
     * @return {Object} this
     */
    appendHTMLEditorNode: function(node, target) {
      target.parentNode.appendChild(node);
      return this;
    },

    /**
     * Converts HTML input into Markdown then submits form
     * @return {Object} this
     */
    handleSubmit: function() {
      // Convert to Markdown
      this.cmsFormNode.submit();
      return this;
    },

    /**
     * Handles switch between HTML and Markdown mode
     * @param  {String} mode html|markdown
     * @return {Object} this
     */
    changeMode: function(mode) {
      this.mode = mode;

      switch(mode) {
        case 'html':
          this.show(this.htmlEditorNode).hide(this.markdownEditorNode);
          break;
        case 'markdown':
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
