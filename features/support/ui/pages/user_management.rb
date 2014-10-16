require_relative '../page'

module UI::Pages
  class UserManagement < UI::Page
    set_url '/admin/users'
    element :new_user, '.t-new-user'
    element :create_user, '.t-create-user'
    element :user_name, "#comfy_cms_user_name"
    element :user_email, "#comfy_cms_user_email"
    element :user_password, "#comfy_cms_user_password"
  end
end
