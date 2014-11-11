module FilesHelper
  private

  # The url to a icon representing the file based in its extension.
  def url_of_file_icon(file)
    icon_type = file.file.original_filename.split('.').last.presence || 'default'
    icon_name = [icon_type, 'file_icon.png'].join('_')
    file.is_image? ? file.file.url(:cms_medium) : image_path(icon_name)
  end

  def options_to_sort_files(selected_option:)
    options = {
      t('comfy.admin.cms.files.index.sort_by.name') => :label,
      t('comfy.admin.cms.files.index.sort_by.date') => 'position DESC'
    }
    options_for_select(options, selected_option)
  end

  def options_to_filter_files(selected_option:)
    options = t('comfy.admin.cms.files.index.filter_by.type').split(',').map { |type| [type.strip, type.strip] }
    options_for_select(options, selected_option)
  end
end
