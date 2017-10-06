require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class CategoryDetails < UI::Page
    set_url         '/admin/categories/{id}'
    set_url_matcher /\/admin\/categories\/\d+/

    elements :parent_options, '#comfy_cms_category_parent_id option'
  end
end
