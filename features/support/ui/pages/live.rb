require_relative '../page'

module UI::Pages
  class Live < UI::Page
    set_url '/{locale}/{page_type}/{slug}.json'
  end
end
