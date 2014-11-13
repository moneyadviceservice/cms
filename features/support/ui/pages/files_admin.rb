require_relative '../page'
require_relative '../sections/header'

module UI::Pages
  class FilesAdmin < UI::Page
    set_url         '/admin/sites/{site}/files'
    set_url_matcher /admin\/sites\/\d+\/files/

    element :files_header, '.page-header'

    section :files_filters, '.t-files-filters' do
      section :form, 'form' do
        section  :sort_by,   'select#order' do
          element :name, "option[value='label']"
          element :date, "option[value='position DESC']"
        end
        section  :type,   'select#type' do
          element :doc, "option[value='doc']"
          element :jpg, "option[value='jpg']"
          element :pdf, "option[value='pdf']"
          element :xls, "option[value='xls']"
        end
      end
    end

    section :files_listing, '.t-files-listing' do
      sections :files, 'tr' do
        element :icon,  '.icon'
        element :label, '.item-title'
      end
    end
  end
end
