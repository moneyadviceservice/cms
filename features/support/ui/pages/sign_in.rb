require_relative '../page'

module UI::Pages
  class SignIn < UI::Page
    set_url "/users/sign_in"
    element :email, "#user_email"
    element :password, "#user_password"
    element :log_in, "input[value='Log in']"
  end
end
