require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class Home < UI::Page
    set_url '/cms'

    section :header, UI::Sections::Header, '.page-header'
  end
end
