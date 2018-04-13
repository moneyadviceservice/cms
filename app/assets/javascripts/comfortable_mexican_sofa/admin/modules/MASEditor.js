define([
  'jquery',
  'DoughBaseComponent',
  'editor',
  'scribe-plugin-mastalk',
  'scribe-plugin-linkeditor',
  'scribe-plugin-image-inserter',
  'autosize'
], function(
  $,
  DoughBaseComponent,
  Editor,
  scribePluginMastalk,
  scribePluginLinkEditor,
  scribePluginImageInserter,
  autosize
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
          markdownToolbar: '[data-dough-maseditor-markdown-toolbar]',
          markdownContainer: '[data-dough-maseditor-markdown-container]',
          markdownContent: '[data-dough-maseditor-markdown-content]',
          switchModeContainer: '[data-dough-maseditor-mode-switch]'
        },
        uiEvents: {
          'submit': '_handleFormSubmit',
          'change [data-dough-maseditor-mode-switch]': '_handleChangeMode'
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
            a: { href: true, id: true, title: true },
            h2: { id: true },
            h3: { id: true },
            h4: { id: true },
            h5: { id: true },
            sub: {},
            sup: {},
            span: { 'class': true, id: true },
            img: { 'class': true, src: true, alt: true }
          }
        }
      }
    };
    this.classActive = 'is-active';
    this.mode = 'html';
  }

  DoughBaseComponent.extend(MASEditor);

  MASEditor.componentName = 'MASEditor';

  MASEditorProto = MASEditor.prototype;

  MASEditorProto.init = function(initialised) {
    this._cacheComponentElements();
    this._stripEditorWhitespace();
    this.enableToolbar('html');

    this.editorLib = new Editor(
      this.$htmlContent[0],
      this.markdownContent,
      this.$htmlToolbar[0],
      this.editorOptions
    );
    this.editorLib.editor.use(scribePluginLinkEditor('add-link'));
    this.editorLib.editor.use(scribePluginImageInserter('insert-image'));
    this.editorLib.editor.use(scribePluginMastalk('collapsible'));
    this.editorLib.editor.use(scribePluginMastalk('ticks'));
    this.editorLib.editor.use(scribePluginMastalk('addAction'));
    this.editorLib.editor.use(scribePluginMastalk('actionItem'));
    this.editorLib.editor.use(scribePluginMastalk('videoYoutube'));
    this.editorLib.editor.use(scribePluginMastalk('videoBrightcove'));
    this.editorLib.editor.use(scribePluginMastalk('videoVimeo'));
    this.editorLib.editor.use(scribePluginMastalk('video'));
    this.editorLib.editor.use(scribePluginMastalk('callout'));
    this.editorLib.editor.use(scribePluginMastalk('calloutTool'));
    this.editorLib.editor.use(scribePluginMastalk('table'));
    this.editorLib.editor.use(scribePluginMastalk('bullets'));
    this.editorLib.editor.use(scribePluginMastalk('promoBlock'));
    this.editorLib.editor.use(scribePluginMastalk('costCalculator'));

    // FinCap Specific
    this.editorLib.editor.use(scribePluginMastalk('fincap_feedback'));

    this.setupMarkdownContentResize();
    this._initialisedSuccess(initialised);
  };

  MASEditorProto._cacheComponentElements = function() {
    this.$cmsForm = this.$el;
    this.$cmsFormSubmit = this.$el.find(this.config.selectors.cmsFormSubmit);
    this.$toolbarContainer = this.$el.find(this.config.selectors.toolbarContainer);
    this.$htmlToolbar = this.$el.find(this.config.selectors.htmlToolbar);
    this.$htmlContainer = this.$el.find(this.config.selectors.htmlContainer);
    this.$htmlContent = this.$el.find(this.config.selectors.htmlContent);
    this.$markdownContainer = this.$el.find(this.config.selectors.markdownContainer);
    this.$markdownContent = this.$el.find(this.config.selectors.markdownContent);
    this.markdownContent = this.$markdownContent[0];
    this.$markdownToolbar = this.$el.find(this.config.selectors.markdownToolbar);
    this.$switchModeContainer = this.$el.find(this.config.selectors.switchModeContainer);

    this.toolbars = {
      'html': this.$htmlToolbar,
      'markdown': this.$markdownToolbar
    };
  };

  MASEditorProto._stripEditorWhitespace = function() {
    this.markdownContent.value = this.markdownContent.value.split('\n').map(function(e) {
      return e.trim();
    }).join('\n');
  };

  /**
   * Handles Mode button click
   * @param  {Object} button Button DOM node
   * @return {[type]}        [description]
   */
  MASEditorProto._handleChangeMode = function(e) {
    var scrollY = document.body.scrollTop;
    e.preventDefault();
    this.changeMode(this.$switchModeContainer.find(':checked').val());
    document.body.scrollTop = scrollY;
  };

  /**
   * Converts HTML input into Markdown then submits form
   * @return {Object} this
   */
  MASEditorProto._handleFormSubmit = function() {
    if(this.mode === this.editorLib.constants.MODES.HTML) {
      this.editorLib.changeEditingMode(this.editorLib.constants.MODES.MARKDOWN);
    }
  };

  /**
   * Setups the autosize library and triggers initial resize
   * @return {Object} this
   */
  MASEditorProto.setupMarkdownContentResize = function() {
    autosize(this.$markdownContent);
    this.resizeMarkdownContent();
    return this;
  };

  /**
   * Triggers resize event on autosize library
   * @return {Object} this
   */
  MASEditorProto.resizeMarkdownContent = function() {
    this.markdownContent.dispatchEvent(new Event('autosize.update'));
    return this;
  };

  /**
   * [enableToolbar description]
   * @return {[type]} [description]
   */
  MASEditorProto.enableToolbar = function(name) {
    this.toolbars[name].addClass(this.classActive);
    return this;
  };

  /**
   * [disableToolbar description]
   * @return {[type]} [description]
   */
  MASEditorProto.disableToolbar = function(name) {
    this.toolbars[name].removeClass(this.classActive);
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
    this.editorLib.changeEditingMode(this.mode);

    switch(mode) {
      case this.editorLib.constants.MODES.HTML:
        this.enableToolbar('html');
        this.disableToolbar('markdown');
        this.show(this.$htmlContainer).hide(this.$markdownContainer);
        break;
      case this.editorLib.constants.MODES.MARKDOWN:
        this.enableToolbar('markdown');
        this.disableToolbar('html');
        this.show(this.$markdownContainer).hide(this.$htmlContainer);
        this.resizeMarkdownContent();
        break;
      default:
        this.enableToolbar('html');
        this.disableToolbar('markdown');
        this.show(this.$htmlContainer).hide(this.$markdownContainer);
        break;
    }

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
