module FilesHelper

  private

  # The url to a icon representing the file based in its extension.
  def url_of_file_icon(file)
    icon_type = file.file.original_filename.split('.').last.presence || 'default'
    icon_name = [icon_type, 'file_icon.png'].join('_')
    file.is_image? ? file.file.url(:cms_medium) : image_path(icon_name)
  end

end
