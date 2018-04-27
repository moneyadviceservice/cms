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
    section :link_manager, '[data-dough-component="LinkManager"]' do
      section :pages, '#page' do
        element :search_input_box, '#search'
        element :search_button, '.t-search-btn'
        sections :results, '.js-linkable-pages .grid-list--page-listing .grid-list__row:nth-child(1n+2)' do
          element :en, '.grid-list__item:nth-child(0n+1)'
          element :cy, '.grid-list__item:nth-child(0n+2)'
          element :page_name, '.grid-list__item:nth-child(0n+3)'
        end
      end
    end

    element :overview, '#blocks_attributes_1_content'
    element :countries, '#blocks_attributes_2_content'
    element :links_to_research, '#blocks_attributes_3_content'
    element :contact_details, '#blocks_attributes_4_content'
    element :year_of_publication, '#blocks_attributes_5_content'

    element :saving, 'input[value="Saving"]'
    element :financial_capability, 'input[value="Financial Capability"]'
    element :financial_education, 'input[value="Financial Education"]'
    element :insurance_and_protection, 'input[value="Insurance and Protection"]'

    element :united_kingdom, 'input[value="United Kingdom"]'
    element :usa, 'input[value="USA"]'
    element :scotland, 'input[value="Scotland"]'

    element :parents_families, 'input[value="Parents / Families"]'
    element :children, 'input[value="Children (3-11)"]'
    element :young_people, 'input[value="Young People (12-16)"]'

    element :hero_image, '.component_hero_image'
    element :hero_description, '.component_hero_description'
    element :cta_links, '.component_cta_links'
    element :download, '.component_download'
    element :feedback, '.component_feedback'
  end
end
