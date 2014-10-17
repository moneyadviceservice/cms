define([
  'jquery',
  'DoughBaseComponent',
  'editor-plugin-auto-resize-textarea',
  'editor'
], function (
  $,
  DoughBaseComponent,
  editorPluginAutoResizeTextarea,
  Editor
) {
  'use strict';

  var MASEditorProto,
      defaultConfig = {
        selectors: {
          cmsForm: '[data-dough-component="MASEditor"]',
          cmsFormSubmit: '[data-dough-maseditor-form-submit]',
          toolbarContainer: '[data-dough-maseditor-toolbar]',
          htmlToolbar: '[data-dough-maseditor-html-toolbar]',
          htmlContainer: '[data-dough-maseditor-html-container]',
          htmlContent: '[data-dough-maseditor-html-content]',
          markdownContainer: '[data-dough-maseditor-markdown-container]',
          markdownContent: '[data-dough-maseditor-markdown-content]',
          switchModeContainer: '[data-dough-maseditor-mode-switch]'
        },
        uiEvents: {
          'click [data-dough-maseditor-form-submit]': '_handleFormSubmit',
          'change [data-dough-maseditor-mode-switch]': '_handleChangeMode',
          'blur [data-dough-maseditor-html-content]': 'disableHTMLToolbar',
          'focus [data-dough-maseditor-html-content]': 'enableHTMLToolbar'
        }
      };

  /**
   * MASEditor
   * @return {Object} this
   */

  function MASEditor($el, config) {
    MASEditor.baseConstructor.call(this, $el, config, defaultConfig);
    this.editorOptions = {
      editorLibOptions : {
        sanitizer : {
          tags: {
            p: {},
            br: {},
            b: {},
            strong: {},
            strike: {},
            blockquote: {},
            ol: {},
            ul: {},
            li: {},
            a: { href: true },
            h2: {},
            h3: {},
            h4: {},
            h5: {}
          }
        }
      }
    };
    this.classActive = 'is-active';
    this.mode = 'html';
  }

  DoughBaseComponent.extend(MASEditor);
  MASEditorProto = MASEditor.prototype;

  MASEditorProto.init = function(initialised) {    
    this._cacheComponentElements();
    this._stripEditorWhitespace();
    this.enableHTMLToolbar();
    this.editor = new Editor(
      this.$htmlContent[0],
      this.$markdownContent[0],
      this.$htmlToolbar[0],
      this.editorOptions
    );
    this.editor.use(editorPluginAutoResizeTextarea(this.$markdownContent[0]));
    this._initialisedSuccess(initialised);
  };

  MASEditorProto._cacheComponentElements = function() {
    this.$cmsForm = this.$el;
    this.$toolbarContainer = this.$el.find(this.config.selectors.toolbarContainer);
    this.$htmlToolbar = this.$el.find(this.config.selectors.htmlToolbar);
    this.$htmlContainer = this.$el.find(this.config.selectors.htmlContainer);
    this.$htmlContent = this.$el.find(this.config.selectors.htmlContent);
    this.$markdownContainer = this.$el.find(this.config.selectors.markdownContainer);
    this.$markdownContent = this.$el.find(this.config.selectors.markdownContent);
    this.$switchModeContainer = this.$el.find(this.config.selectors.switchModeContainer);
  };

  MASEditorProto._stripEditorWhitespace = function() {
    this.$markdownContent[0].value = this.$markdownContent[0].value.split('\n').map(function(e) {
      return e.trim();
    }).join('\n');
  };

  /**
   * Handles Mode button click
   * @param  {Object} button Button DOM node
   * @return {[type]}        [description]
   */
  MASEditorProto._handleChangeMode = function() {
    this.changeMode(this.$switchModeContainer.find(':checked').val());
  };

  /**
   * Converts HTML input into Markdown then submits form
   * @return {Object} this
   */
  MASEditorProto._handleFormSubmit = function(e) {
    e.preventDefault();
    if(this.mode === this.editor.constants.MODES.HTML) {
      this.editor.changeEditingMode(this.editor.constants.MODES.MARKDOWN);
    }
    this.$cmsForm.submit();
  };

  /**
   * [enableHTMLToolbar description]
   * @return {[type]} [description]
   */
  MASEditorProto.enableHTMLToolbar = function() {
    this.$htmlToolbar.addClass(this.classActive);
    return this;
  };

  /**
   * [disableHTMLToolbar description]
   * @return {[type]} [description]
   */
  MASEditorProto.disableHTMLToolbar = function() {
    this.$htmlToolbar.removeClass(this.classActive);
    return this;
  };

  /**
   * Handles switch between HTML and Markdown mode
   * @param  {String} mode html|markdown
   * @return {Object} this
   */
  MASEditorProto.changeMode = function(mode) {
    if(mode === this.mode) return;

    this.mode = mode;

    switch(mode) {
      case this.editor.constants.MODES.HTML:
        this.enableHTMLToolbar();
        this.show(this.$htmlContainer).hide(this.$markdownContainer);
        break;
      case this.editor.constants.MODES.MARKDOWN:
        this.disableHTMLToolbar();
        this.show(this.$markdownContainer).hide(this.$htmlContainer);
        break;
      default:
        this.enableHTMLToolbar();
        this.show(this.$htmlContainer).hide(this.$markdownContainer);
        break;
    }

    this.editor.changeEditingMode(this.mode);

    return this;
  };

  /**
   * Adds an active class to a DOM node
   * @param  {Object} node Target DOM node
   * @return {Object} this
   */
  MASEditorProto.show = function($el) {
    $el.addClass(this.classActive);
    return this;
  };

  /**
   * Removes active class from a DOM node
   * @param  {Object} node Target DOM node
   * @return {Object} this
   */
  MASEditorProto.hide = function($el) {
    $el.removeClass(this.classActive);
    return this;
  };

  return MASEditor;
});
