class PagePresenter < Presenter
  def last_update
    I18n.l(updated_at, format: :date_with_time)
  end
end
