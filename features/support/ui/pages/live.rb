require_relative '../page'

module UI::Pages
  class Live < UI::Page
    set_url '/{locale}/{slug}.json'
  end
end
