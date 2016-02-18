require_relative '../page'

module UI::Pages
  class Articles < UI::Page
    set_url         '/admin/sites/{site}/pages'
    set_url_matcher /admin\/sites\/\d+\/pages/
  end
end
