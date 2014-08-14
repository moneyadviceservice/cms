// Overwrite this file in your application /app/assets/javascripts/comfortable_mexican_sofa/admin/application.js
//= require requirejs/require
//= require require_config

window.CMS.wysiwyg = function() {
  require([
    'mas-editor'
  ], function (
    masEditor
  ) {
    var markdownEditorNode = document.querySelector('textarea[data-cms-rich-text]'),
        classActive = 'is-active',
        htmlEditorNode;

    htmlEditorNode = document.querySelector('.js-html-editor');

    if(!markdownEditorNode) return;

    console.log(document.querySelector('.js-html-editor-toolbar'));

    masEditor.init({
      editorContainer: document.querySelector('.l-editor'),
      cmsFormNode: document.querySelector('#edit_page'),
      toolbarNode: document.querySelector('.js-html-editor-toolbar'),
      htmlEditorNode: htmlEditorNode,
      htmlEditorContentNode: document.querySelector('.js-html-editor-content'),
      markdownEditorNode: markdownEditorNode,
      switchModeButtonNodes: document.querySelectorAll('.js-switch-mode'),
      classActive : 'is-active'
    });

    markdownEditorNode.classList.add('editor','editor--markdown');
    htmlEditorNode.classList.add(classActive);
  });
};
