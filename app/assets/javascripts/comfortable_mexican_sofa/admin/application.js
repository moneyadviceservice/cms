// Overwrite this file in your application /app/assets/javascripts/comfortable_mexican_sofa/admin/application.js
//= require requirejs/require
//= require require_config

window.CMS.wysiwyg = function() {
  require([
    'mas-editor'
  ], function (
    masEditor
  ) {
    var markdownEditorNode = document.querySelector('textarea[data-cms-rich-text]');

    if(!markdownEditorNode) return;

    masEditor.init({
      cmsFormNode: document.querySelector('#edit_page'),
      toolbarNode: document.querySelector('.js-html-editor-toolbar'),
      htmlEditorNode: document.querySelector('.js-html-editor'),
      htmlEditorContentNode: document.querySelector('.js-html-editor-content'),
      markdownEditorNode: markdownEditorNode,
      switchModeButtonNodes: document.querySelectorAll('.js-switch-mode')
    });
  });
};
