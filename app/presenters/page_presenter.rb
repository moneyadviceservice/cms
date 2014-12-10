class PagePresenter < Presenter
  def last_update
    I18n.l(updated_at, format: :date_with_time)
  end

  def preview_url
    preview_domain = ComfortableMexicanSofa.config.preview_domain
    "#{url_scheme}#{preview_domain}/#{site.label}/articles/#{slug}/preview"
  end

  private

  def url_scheme
    return 'https://' if Rails.env.production?

    'http://'
  end
end
