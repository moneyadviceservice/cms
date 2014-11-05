require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class FilesAdmin < UI::Page
    set_url         '/admin/sites/{site}/files'
    set_url_matcher /admin\/\sites\/\d+\/files/

    element :files_header, '.page-header'

    section :files_filters, '.js-files-filters' do
      section :form, 'form' do
        section  :sort_by,   'select input#order' do
          elements :options, 'option'
        end
      end
    end

    section :files_listing, '.js-files-listing' do
    end
  end
end
