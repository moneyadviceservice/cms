// Overwrite this file in your application /app/assets/javascripts/comfortable_mexican_sofa/admin/application.js
//= require requirejs/require
//= require require_config

window.CMS.wysiwyg = function() {
  require([
    'mas-editor'
  ], function (
    masEditor
  ) {
    var markdownEditorContentNode = document.querySelector('.js-markdown-editor-content'),
        classActive = 'is-active',
        htmlEditorNode;
    'use strict';

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
      switchModeButtonNodes: document.querySelectorAll('.js-switch-mode'),
      classActive : 'is-active'
    });
  });
};
