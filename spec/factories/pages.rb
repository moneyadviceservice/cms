FactoryGirl.define do
  factory :page, class: Comfy::Cms::Page do
    site
    layout
    label          'Default Page'
    full_path      '/'
    children_count 1
    position       0
    is_published   true
    state          :published
    content_cache %{
      layout_content_a
      default_page_text_content_a
      default_snippet_content
      default_page_text_content_b
      layout_content_b
      default_snippet_content
      layout_content_c
    }
  end

  factory :child_page, class: Comfy::Cms::Page do
    site
    layout
    parent { create(:page) }
    label 'Child Page'
    slug 'child-page'
    full_path '/child-page'
    children_count 0
    content_cache %{
      layout_content_a

      layout_content_b
      default_snippet_content
      layout_content_c
    }
  end
end