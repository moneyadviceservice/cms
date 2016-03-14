require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class New < UI::Page
    set_url '/admin/sites/{site}/pages/new'
    set_url_matcher /\admin\/sites\/\d+\/pages\/new/

    section :header, UI::Sections::Header, '.page-header'

    element :publish, '#new_page input.btn-primary'
    element :upload_word, '#upload-word-doc'
    element :page_name, '#page_label'
    element :tags_input_box, '.t-tags-select .search-field input'
    elements :tags_choices,  '.t-tags-select option'
    elements :tags_chosen,   '.t-tags-select .search-choice'
    element :meta_description, '#page_meta_description'
    element :meta_title, '#page_meta_title'
    element :save_button, '.t-create_initial_draft'
  end
end
