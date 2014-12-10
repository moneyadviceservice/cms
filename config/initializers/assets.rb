Rails.application.configure do

  config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

# Fonts and images
  config.assets.precompile << /\.(?:png|svg|eot|woff|ttf)$/

# Application Stylesheets
  config.assets.precompile += %w(comfortable_mexican_sofa/admin/basic.css
                                  components-font-awesome/css/font-awesome.css)
# Application JavaScript
  config.assets.precompile += %w(application.js)

# Snippets source files
  config.assets.precompile += %w(comfortable_mexican_sofa/admin/modules/mastalk/snippets/collapsible.md)

# Editor JavaScript/snippet content
  config.assets.precompile += %w(mas-cms-editor/src/app/constants/constants.js
                                  mas-cms-editor/src/app/config/config.js
                                  mas-cms-editor/src/app/app.js
                                  mas-cms-editor/src/app/modules/editor-lib-wrapper/editor-lib-wrapper.js
                                  mas-cms-editor/src/app/modules/source-converter/source-converter.js
                                  mas-cms-editor/src/app/plugins/editor-sticky-toolbar/editor-sticky-toolbar.js
                                  mas-cms-editor/src/app/plugins/editor-auto-resize-textarea/editor-auto-resize-textarea.js
                                  mas-cms-editor/src/app/shims/mutationobserver.min.js
                                  comfortable_mexican_sofa/admin/modules/*.js)

# Vendor JavaScript
  config.assets.precompile += %w(requirejs/require.js
                                  jquery/dist/jquery.min.js
                                  he/he.js
                                  rsvp/rsvp.amd.js
                                  eventsWithPromises/src/eventsWithPromises.js
                                  scribe/scribe.js
                                  scribe-plugin-blockquote-command/scribe-plugin-blockquote-command.js
                                  scribe-plugin-formatter-plain-text-convert-new-lines-to-html/scribe-plugin-formatter-plain-text-convert-new-lines-to-html.js
                                  scribe-plugin-heading-command/scribe-plugin-heading-command.js
                                  scribe-plugin-keyboard-shortcuts/scribe-plugin-keyboard-shortcuts.js
                                  scribe-plugin-link-prompt-command/scribe-plugin-link-prompt-command.js
                                  scribe-plugin-sanitizer/scribe-plugin-sanitizer.js
                                  scribe-plugin-toolbar/scribe-plugin-toolbar.js
                                  text/text.js
                                  marked/lib/marked.js
                                  to-markdown/src/to-markdown.js
                                  dough/assets/js/lib/componentLoader.js
                                  dough/assets/js/lib/featureDetect.js
                                  dough/assets/js/components/DoughBaseComponent.js
                                  dough/assets/js/components/Collapsable.js
                                  dough/assets/js/components/TabSelector.js
                                  dough/assets/js/lib/mediaQueries.js
                                  jqueryThrottleDebounce/jquery.ba-throttle-debounce.js
                                  modernizr/modernizr.js
                                  taggle.js/dist/taggle.min.js
                                  chosen-build/chosen.jquery.js
                                  dialog-polyfill/dialog-polyfill.js
                                  rangy-official/rangy-core.js
                                  rangy-official/rangy-selectionsaverestore.js
																	filament-sticky/fixedsticky.js
                                  filament-fixed/fixedfixed.js)
end
