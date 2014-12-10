class FilePresenter < Presenter
  def id
    "file_#{object.id}"
  end

  def full_path
    "http://#{object.site.hostname}/#{object.file.url}"
  end

  def edit_url
    url_helpers.edit_site_file_path(site, object)
  end
end
