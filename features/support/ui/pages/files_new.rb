require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class FilesNew < UI::Page
    set_url         '/admin/sites/{site}/files/new'
    set_url_matcher /admin\/sites\/\d+\/files\/new/

    section :files_header, UI::Sections::Header, '.page-header'

    element :file_label, '#file_label'
    element :file_file,  '#file_file'
    element :file_description, '#file_description'
  end
end
