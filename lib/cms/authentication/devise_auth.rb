module Cms
  module DeviseAuth
    def authenticate
      redirect_to new_user_session_path unless current_user
    end
  end
end
