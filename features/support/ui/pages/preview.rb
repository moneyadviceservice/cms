require_relative '../page'

module UI::Pages
  class Preview < UI::Page
    set_url '/preview/{locale}/{slug}.json'
  end
end
