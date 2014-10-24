var tests = [];
var replaceModulePath;
var file;
var bowerPath = 'vendor/assets/bower_components/';

replaceModulePath = function (path) {
  'use strict';
  return path.replace(/^\/base\//, '').replace(/\.js$/, '');
};

for (file in window.__karma__.files) {
  if (/spec\.js$/i.test(file)) {
    tests.push(replaceModulePath(file));
  }
}

requirejs.config({
  baseUrl: '/base',
  deps: tests,
  paths: {

     // PhantomJS shims NOTE: Can be retired upon release of PhantomJS v2.0
    'phantom-shims' : 'spec/javascripts/helpers/shims/phantom-shims',

    // Editor core
    'constants': bowerPath + 'mas-cms-editor/src/app/constants/constants',
    'config': bowerPath + 'mas-cms-editor/src/app/config/config',
    'editor': bowerPath + 'mas-cms-editor/src/app/app',

    // Editor modules
    'editor-lib-wrapper': bowerPath + 'mas-cms-editor/src/app/modules/editor-lib-wrapper/editor-lib-wrapper',
    'source-converter': bowerPath + 'mas-cms-editor/src/app/modules/source-converter/source-converter',

    // Editor plugins
    'editor-plugin-sticky-toolbar': bowerPath + 'mas-cms-editor/src/app/plugins/editor-sticky-toolbar/editor-sticky-toolbar',
    'editor-plugin-auto-resize-textarea': bowerPath + 'mas-cms-editor/src/app/plugins/editor-auto-resize-textarea/editor-auto-resize-textarea',

    // Editor Shims
    'mutationobserver-shim': bowerPath + 'mas-cms-editor/src/app/shims/mutationobserver.min',

    // Application modules
    'URLToggler': 'app/assets/javascripts/comfortable_mexican_sofa/admin/modules/URLToggler',
    'MASEditor': 'app/assets/javascripts/comfortable_mexican_sofa/admin/modules/MASEditor',
    'ElementHider': 'app/assets/javascripts/comfortable_mexican_sofa/admin/modules/ElementHider',
    'FileInputSubmit': 'app/assets/javascripts/comfortable_mexican_sofa/admin/modules/FileInputSubmit',
    'AutoComplete': 'app/assets/javascripts/comfortable_mexican_sofa/admin/modules/AutoComplete',
    'Slugifier': 'app/assets/javascripts/comfortable_mexican_sofa/admin/modules/Slugifier',
    'MirrorInputValue': 'app/assets/javascripts/comfortable_mexican_sofa/admin/modules/MirrorInputValue',
    'Popover': 'app/assets/javascripts/comfortable_mexican_sofa/admin/modules/Popover',

    // Dough base modules
    'componentLoader': bowerPath + 'dough/assets/js/lib/componentLoader',
    'DoughBaseComponent': bowerPath + 'dough/assets/js/components/DoughBaseComponent',
    'featureDetect': bowerPath + 'dough/assets/js/lib/featureDetect',

    // Dough components
    'Collapsable': bowerPath + 'dough/assets/js/components/Collapsable',

    // Third-party dependencies
    'jquery': bowerPath + 'jquery/dist/jquery.min',
    'he': bowerPath + 'he/he',
    'rsvp': bowerPath + 'rsvp/rsvp.amd',
    'eventsWithPromises': bowerPath + 'eventsWithPromises/src/eventsWithPromises',
    'scribe': bowerPath + 'scribe/scribe',
    'scribe-plugin-blockquote-command': bowerPath + 'scribe-plugin-blockquote-command/scribe-plugin-blockquote-command',
    'scribe-plugin-formatter-plain-text-convert-new-lines-to-html': bowerPath + 'scribe-plugin-formatter-plain-text-convert-new-lines-to-html/scribe-plugin-formatter-plain-text-convert-new-lines-to-html',
    'scribe-plugin-heading-command': bowerPath + 'scribe-plugin-heading-command/scribe-plugin-heading-command',
    'scribe-plugin-keyboard-shortcuts': bowerPath + 'scribe-plugin-keyboard-shortcuts/scribe-plugin-keyboard-shortcuts',
    'scribe-plugin-link-prompt-command': bowerPath + 'scribe-plugin-link-prompt-command/scribe-plugin-link-prompt-command',
    'scribe-plugin-sanitizer': bowerPath + 'scribe-plugin-sanitizer/scribe-plugin-sanitizer',
    'scribe-plugin-toolbar': bowerPath + 'scribe-plugin-toolbar/scribe-plugin-toolbar',
    'marked': bowerPath + 'marked/lib/marked',
    'to-markdown' : bowerPath + 'to-markdown/src/to-markdown',
    'chosen': bowerPath + 'chosen-build/chosen.jquery'
  },
  shim : {
    'to-markdown' : {
      deps : ['he']
    },
    'chosen': {
      exports: 'Chosen',
      deps: ['jquery']
    }
  },
  callback: window.__karma__.start
});
