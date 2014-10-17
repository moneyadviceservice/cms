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
        // uiEvents: {
        //   'click [data-dough-element-hider-close]': 'hide'
        // }
      };

  /**
   * MASEditor
   * @return {Object} this
   */

  function MASEditor($el, config) {
    MASEditor.baseConstructor.call(this, $el, config, defaultConfig);
    this.cmsFormNode = $el[0];
    this.toolbarNode = document.querySelector('.js-html-editor-toolbar');
    this.htmlEditorNode = document.querySelector('.js-html-editor');
    this.htmlEditorContentNode = document.querySelector('.js-html-editor-content');
    this.markdownEditorNode = document.querySelector('.js-markdown-editor');
    this.markdownEditorContentNode = document.querySelector('.js-markdown-editor-content');
    this.switchModeTriggerNodes = document.querySelectorAll('.js-switch-mode');
    this.editorOptions = {
      editorLibOptions : {
        sanitizer : {
          tags: {
            p: {},
            br: {},
            b: {},
            strong: {},
            i: {},
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
    this.stripEditorWhitespace();
    this.editor = new Editor(
      this.htmlEditorContentNode,
      this.markdownEditorContentNode,
      this.toolbarNode,
      this.editorOptions
    );
    this.editor.use(editorPluginAutoResizeTextarea(this.markdownEditorContentNode));
    this.setupEventListeners();
    this.setupAppEvents();
    this.setupToolbar();
    this._initialisedSuccess(initialised);
  };

  MASEditorProto.stripEditorWhitespace = function() {
    this.markdownEditorContentNode.value = this.markdownEditorContentNode.value.split('\n').map(function(e) {
      return e.trim();
    }).join('\n');
  };

  /**
   * Bind DOM events
   * @return {Object} this
   */
  MASEditorProto.setupEventListeners = function() {
    var _this = this;

    // Catches form submit and delegates to a handler function
    this.cmsFormNode.addEventListener('submit', function(event) {
      event.preventDefault();
      _this.handleSubmit();
    });

    this.setupModeButton();

    return this;
  };

  /**
   * [setupAppEvents description]
   * @return {[type]} [description]
   */
  MASEditorProto.setupAppEvents = function() {
    this.editor.events.subscribe('mode:changed', this.handleChangeModeEvent, this);
    return this;
  };

  /**
   * Setups mode switching buttons
   * @return {Object} this
   */
  MASEditorProto.setupModeButton = function() {
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
  };

  /**
   * [setupToolbar description]
   * @return {[type]} [description]
   */
  MASEditorProto.setupToolbar = function() {
    this.toolbarNode.classList.add(this.classActive);
    return this;
  };

  /**
   * Handles Mode button click
   * @param  {Object} button Button DOM node
   * @return {[type]}        [description]
   */
  MASEditorProto.handleChangeModeEvent = function(mode) {
    Array.prototype.map.call(this.switchModeTriggerNodes, function(node) {
      node.classList.remove(this.classActive);
      if(node.value === mode) {
        node.click();
      }
    }.bind(this));
  };


  /**
   * Converts HTML input into Markdown then submits form
   * @return {Object} this
   */
  MASEditorProto.handleSubmit = function() {
    if(this.mode === this.editor.constants.MODES.HTML) {
      this.editor.changeEditingMode(this.editor.constants.MODES.MARKDOWN);
    }
    this.cmsFormNode.submit();
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
  };

  /**
   * Adds an active class to a DOM node
   * @param  {Object} node Target DOM node
   * @return {Object} this
   */
  MASEditorProto.show = function(node) {
    node.classList.add(this.classActive);
    return this;
  };

  /**
   * Removes active class from a DOM node
   * @param  {Object} node Target DOM node
   * @return {Object} this
   */
  MASEditorProto.hide = function(node) {
    node.classList.remove(this.classActive);
    return this;
  };

  return MASEditor;
});
