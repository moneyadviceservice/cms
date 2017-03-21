class FilePresenter < Presenter
  def label_id
    "file_#{object.id}"
  end

  def full_path(options={})
    object.file.path(options[:style])
  end

  def edit_url
    url_helpers.edit_site_file_path(site, object)
  end

  def image_tag_code
    "<img src='#{full_path}' alt='#{object.description}'>"
  end
end
