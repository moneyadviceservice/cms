class FilePresenter < Presenter
  def full_path
    "#{url_scheme}://#{object.site.hostname}/#{object.file.url}"
  end

  def url_scheme
    return 'https' if Rails.env.production?

    'http'
  end
end
