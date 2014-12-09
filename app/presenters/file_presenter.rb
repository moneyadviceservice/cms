class FilePresenter < Presenter
  def id
    "file_#{object.id}"
  end

  def full_path
    "http://#{object.site.hostname}/#{object.file.url}"
  end
end
