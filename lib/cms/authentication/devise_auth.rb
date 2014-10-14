module Cms
  module DeviseAuth
    def authenticate
      unless current_user
        redirect_to new_user_session_path
      end
    end
  end
end
