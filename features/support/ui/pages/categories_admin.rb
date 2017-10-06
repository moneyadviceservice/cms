require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class CategoriesAdmin < UI::Page
    set_url         '/admin/categories'
    set_url_matcher /\/admin\/categories/

    elements :category_links, '.sortable-list__link'
  end
end
