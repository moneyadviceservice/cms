var tests = [];
var replaceModulePath;
var file;
var bowerPath = 'vendor/assets/bower_components/';

replaceModulePath = function (path) {
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
    // Editor
    'constants': bowerPath + 'mas-cms-editor/src/app/constants/constants',
    'config': bowerPath + 'mas-cms-editor/src/app/config/config',
    'mas-editor' : 'app/assets/javascripts/comfortable_mexican_sofa/admin/mas-editor',
    'editor' : bowerPath + 'mas-cms-editor/src/app/app',
    'source-converter': bowerPath + 'mas-cms-editor/src/app/modules/source-converter/source-converter',
    'scribe-wrapper': bowerPath + 'mas-cms-editor/src/app/modules/scribe-wrapper/scribe-wrapper',
    'editor-plugin-sticky-toolbar': bowerPath + 'mas-cms-editor/src/app/plugins/editor-sticky-toolbar/editor-sticky-toolbar',

    // PhantomJS shims NOTE: Can be retired upon release of PhantomJS v2.0
    'phantom-shims' : 'spec/javascripts/helpers/shims/phantom-shims',

    // 3rd-party libraries
    'text': bowerPath + 'requirejs-text/text',
    'rsvp': bowerPath + 'rsvp/rsvp.amd',
    'eventsWithPromises': bowerPath + 'eventsWithPromises/src/eventsWithPromises',
    'to-markdown': bowerPath + 'to-markdown/src/to-markdown',
    'marked': bowerPath + 'marked/lib/marked',
    'he': bowerPath + 'he/he',
    'scribe': bowerPath + 'scribe/scribe',
    'scribe-plugin-blockquote-command': bowerPath + 'scribe-plugin-blockquote-command/scribe-plugin-blockquote-command',
    'scribe-plugin-formatter-plain-text-convert-new-lines-to-html': bowerPath + 'scribe-plugin-formatter-plain-text-convert-new-lines-to-html/scribe-plugin-formatter-plain-text-convert-new-lines-to-html',
    'scribe-plugin-heading-command': bowerPath + 'scribe-plugin-heading-command/scribe-plugin-heading-command',
    'scribe-plugin-keyboard-shortcuts': bowerPath + 'scribe-plugin-keyboard-shortcuts/scribe-plugin-keyboard-shortcuts',
    'scribe-plugin-link-prompt-command': bowerPath + 'scribe-plugin-link-prompt-command/scribe-plugin-link-prompt-command',
    'scribe-plugin-sanitizer': bowerPath + 'scribe-plugin-sanitizer/scribe-plugin-sanitizer',
    'scribe-plugin-toolbar': bowerPath + 'scribe-plugin-toolbar/scribe-plugin-toolbar'
  },
  shim : {
    'to-markdown' : {
      deps : ['he']
    }
  },
  callback: window.__karma__.start
});
