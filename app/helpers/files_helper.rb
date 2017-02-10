module FilesHelper
  private

  IMAGE_STYLES = %w(Original Extra_small Small Medium Large)
  FA_FILE_TYPES = { 'doc'  => 'fa-file-word-o',
                    'docx' => 'fa-file-word-o',
                    'xls'  => 'fa-file-excel-o',
                    'xlsx' => 'fa-file-excel-o',
                    'pdf'  => 'fa-file-pdf-o' }

  # The url to a icon representing the file based in its extension.
  def url_of_file_icon(file)
    icon_type = file.file.original_filename.split('.').last.presence || 'default'
    icon_name = [icon_type, 'file_icon.png'].join('_')
    file.is_image? ? file.file.url(:cms_medium) : image_path(icon_name)
  end

  # The url to a icon representing the file based in its extension.
  def icon_class_of(file)
    extension = file.file.original_filename.split('.').last
    "fa #{FA_FILE_TYPES[extension]}"
  end

  def options_to_sort_files(selected_option:)
    options = {
      t('files.index.sort_by.name') => :label,
      t('files.index.sort_by.date') => 'position DESC'
    }
    options_for_select(options, selected_option)
  end

  def options_to_filter_files(selected_option:)
    options = t('files.index.filter_by.type').split(',').map { |type| [type.strip, type.strip] }
    options_for_select(options, selected_option)
  end

  def options_to_filter_images
    t('files.images.filter_by').map { |type| [type.strip, type.strip] }
  end

  # The header to show in the files index page.
  def files_page_header(search_term:)
    header = search_term.present? ? t('search.results') : t('comfy.admin.cms.files.index.title')
    content_tag(:h1, header)
  end
end
