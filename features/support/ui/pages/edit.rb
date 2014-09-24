require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class Edit < UI::Page
    set_url '/admin/sites/{site}/pages/{page}/edit'
    set_url_matcher /\admin\/\sites\/\d+\/pages\/\d+\/edit/

    section :header, UI::Sections::Header, '.page-header'

    element :preview, '#preview'

    element :categories, '#categories--select'
    element :save, '.t-save_unsaved'
    element :publish, 'button[type="submit"][value="publish"]'
    element :category_remove, '.search-choice-close'
    element :category_chosen, '.chosen-choices'
    elements :categories_selected, '#categories--select > option[selected]'
    element :site_toggle_cy, "#site__mirrors input#edit-mode_cy"
    element :site_toggle_en, "#site__mirrors input#edit-mode_en"
    element :status, '#t-status'
  end
end
