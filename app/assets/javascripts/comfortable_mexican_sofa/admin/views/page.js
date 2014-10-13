//= require requirejs/require
//= require require_config

require([
  'mas-editor',
  'editor-plugin-auto-resize-textarea',
  'word-upload',
  'element-hider'
], function (
  masEditor,
  editorPluginAutoResizeTextarea,
  wordUpload,
  ElementHider
) {
  'use strict';
  var markdownEditorContentNode = document.querySelector('.js-markdown-editor-content');

  if(!markdownEditorContentNode) return;

  markdownEditorContentNode.value = markdownEditorContentNode.value.split('\n').map(function(e) {
    return e.trim();
  }).join('\n');

  masEditor.init({
    editorContainer: document.querySelector('.l-editor'),
    cmsFormNode: document.querySelector('#edit_page') || document.querySelector('#new_page'),
    toolbarNode: document.querySelector('.js-toolbar'),
    htmlEditorNode: document.querySelector('.js-html-editor'),
    htmlEditorContentNode: document.querySelector('.js-html-editor-content'),
    markdownEditorNode: document.querySelector('.js-markdown-editor'),
    markdownEditorContentNode: markdownEditorContentNode,
    switchModeTriggerNodes: document.querySelectorAll('.js-switch-mode'),
    editorOptions: {
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
    }
  });

  masEditor.editor.use(editorPluginAutoResizeTextarea(markdownEditorContentNode));

  var focusOnTitle = function() {
    var el = document.querySelector('input#page_label');
    el.value = el.value;
  };

  setTimeout(focusOnTitle, 500);

  // Setup Word upload form elements
  wordUpload.init({
    showConfirm: true,
    fileInputNode: document.querySelector('.js-word-upload-file-input'),
    activateFileInputNode: document.querySelector('.js-activate-word-upload-form'),
    wordFormNode: document.querySelector('.js-word-upload-form')
  });

  // Enables ElementHider script
  if(document.querySelector('.js-alert')) {
    new ElementHider({
      mainNode: document.querySelector('.js-alert'),
      closeNode: document.querySelector('.js-close-alert'),
      delay: 3000
    }).init();
  }

  // Enables switching between EN and CY versions of article
  $('.js-language-switcher').change(function() {
    window.location = $(this).find('input:checked').data()['value'];
  });
});
