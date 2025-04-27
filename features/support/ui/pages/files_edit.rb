require_relative '../page'

module UI::Pages
  class FilesEdit < UI::Page
    set_url         '/admin/sites/{site}/files/{file}/edit'
    set_url_matcher /admin\/sites\/\d+\/files\/\d+\/edit/
  end
end
