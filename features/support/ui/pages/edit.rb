require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class Edit < UI::Page
    set_url '/admin/sites/1/pages/1/edit'

    section :header, UI::Sections::Header, '.page-header'

    element :preview, '#preview'
  end
end
