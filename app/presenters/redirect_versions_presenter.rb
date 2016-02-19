class RedirectVersionsPresenter < Presenter
  def last_updated_by
    if user
      user.email_local_part
    else
      'deleted user'
    end
  end
end
