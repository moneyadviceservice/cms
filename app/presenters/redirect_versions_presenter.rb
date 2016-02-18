class RedirectVersionsPresenter < Presenter
  def last_updated_by
    begin
      user.email_local_part
    rescue ActiveRecord::RecordNotFound => e
      'deleted user'
    end
  end
end
