require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class New < UI::Page
    set_url '/admin/sites/{site}/pages/new'
    set_url_matcher /\admin\/\sites\/\d+\/pages\/new/

    section :header, UI::Sections::Header, '.page-header'

    element :publish, '#new_page input.btn-primary'
  end
end
