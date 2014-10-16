require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class TagsAdmin < UI::Page
    set_url         '/admin/tags'
    set_url_matcher /\/admin\/tags/

    section :tags_header, UI::Sections::Header, '.page-header'

    section :tags_creation, '.js-tags-creation' do
      element :label, 'label'
      element :box,   '.js-tags-add-value'
      element :submit_button,  '.js-tags-add-submit'
    end

    section :tags_listing, '.js-tags-listing' do
      element  :info,            'h2'
      elements :tag_index_links, '.js-tags-starting-by-link'
      section  :header, '.js-tags-existing-header' do
        element :existing_tags_msg, '.js-existing-tags-msg'
        element :no_tags_msg,       '.js-tags-no-tags-msg'
      end
      section  :list, '.js-tags-existing' do
        sections :tags, '.tag' do
          element :value, 'span'
          element :close, '.close'
        end
      end
    end
  end
end
