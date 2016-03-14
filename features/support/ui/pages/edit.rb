require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class Edit < UI::Page
    set_url '/admin/sites/{site}/pages/{page}/edit'
    set_url_matcher /\admin\/sites\/\d+\/pages\/\d+\/edit/

    section :header, UI::Sections::Header, '.page-header'

    element :preview, '#preview'
    element :content, '.editor--markdown textarea'
    element :page_name, '#page_label'
    element :categories, '.t-categories-select'
    element :save_button, '.t-create_initial_draft'
    element :publish, 'button[type="submit"][value="publish"]'
    element :publish_changes, 'button[type="submit"][value="publish_changes"]'
    element :create_new_draft, 'button[type="submit"][value="create_new_draft"]'
    element :delete_page, '.t-delete_page'
    element :schedule, '.t-schedule'
    element :save_changes_to_draft, '.t-save-changes-to-draft'
    element :category_remove, '.search-choice-close'
    element :category_chosen, '#categories_chosen .chosen-choices'
    elements :categories_selected, '.t-categories-select > option[selected]'
    element :tags_input_box, '.t-tags-select .search-field input'
    elements :tags_choices,  '.t-tags-select > option'
    elements :tags_chosen, '.t-tags-select .search-choice'
    element :site_toggle_cy, "#site__mirrors input#edit-mode_cy"
    element :site_toggle_en, "#site__mirrors input#edit-mode_en"
    element :status, '#t-status'
    element :regulated_checkbox, '#page_regulated_box'
    element :activity_log_button, '.activity-log-button'
    element :activity_log_box, '.activity-log-box'
  end
end
