require_relative '../page'
require_relative '../sections/header'
require_relative '../sections/tag'

module UI::Pages
  class TagsAdmin < UI::Page
    set_url         '/admin/tags'
    set_url_matcher /\/admin\/tags/

    section :tags_header, UI::Sections::Header, '.t-page-header'

    section :tags_creation, '.js-tags-creation' do
      element  :label, 'label'
      element  :box,   '.js-tags-display input.taggle_input'
      sections :tags,  UI::Sections::Tag, '.tag'

    end

    section :dialog, '.js-dialog-target' do
      element :delete_btn, '[data-dough-tagmanager-delete]'
    end

    section :tags_listing, '.js-tags-listing' do
      element  :info,            'h2'
      elements :tag_index_links, '.js-tags-starting-by-link'
      section  :header, '.js-tags-existing-header' do
        element :existing_tags_msg, '.js-existing-tags-msg'
        element :no_tags_msg,       '.js-tags-no-tags-msg'
      end
      section  :list, '.js-tags-existing' do
        sections :tags,  UI::Sections::Tag, '.tag'
      end
    end
  end
end
