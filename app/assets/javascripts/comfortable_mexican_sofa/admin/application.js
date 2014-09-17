// Overwrite this file in your application /app/assets/javascripts/comfortable_mexican_sofa/admin/application.js
//= require requirejs/require
//= require require_config

window.CMS.wysiwyg = function() {
  'use strict';
  require([
    'mas-editor',
    'editor-plugin-auto-resize-textarea'
  ], function (
    masEditor,
    editorPluginAutoResizeTextarea
  ) {
    var markdownEditorContentNode = document.querySelector('.js-markdown-editor-content');

    if(!markdownEditorContentNode) return;

    markdownEditorContentNode.value = markdownEditorContentNode.value.split("\n").map(function(e) { return e.trim() }).join("\n");

    masEditor.init({
      editorContainer: document.querySelector('.l-editor'),
      cmsFormNode: document.querySelector('#edit_page') || document.querySelector('#new_page'),
      toolbarNode: document.querySelector('.js-toolbar'),
      htmlEditorNode: document.querySelector('.js-html-editor'),
      htmlEditorContentNode: document.querySelector('.js-html-editor-content'),
      markdownEditorNode: document.querySelector('.js-markdown-editor'),
      markdownEditorContentNode: markdownEditorContentNode,
      switchModeTriggerNodes: document.querySelectorAll('.js-switch-mode')
    });

    masEditor.editor.use(editorPluginAutoResizeTextarea(markdownEditorContentNode));

    var focusOnTitle = function() {
      var el = document.querySelector('input#page_label');
      el.value = el.value;
    };

    setTimeout(focusOnTitle, 500);
  });
};
