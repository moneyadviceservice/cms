require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class TagsAdmin < UI::Page
    set_url         '/admin/tags'
    set_url_matcher /\/admin\/tags/

    section :tags_header, UI::Sections::Header, '.page-header'

    section :tags_creation, '.js-tags-creation' do
      element :label, 'label'
      element :box,   '.js-tags-display input.taggle_input'
    end

    section :tags_listing, '.js-tags-listing' do
      element :label, 'label'
      section :list,  '.js-tags-existing' do
        elements :tags, '.tag'
      end
    end
  end
end
