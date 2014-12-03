require_relative '../page'

module UI::Pages
  class EditUser < UI::Page
    set_url '/admin/users/{user_id}/edit'
    element :user_name, '#comfy_cms_user_name'
    element :user_email, '#comfy_cms_user_email'
    element :user_password, '#comfy_cms_user_password'
    element :user_admin, '#comfy_cms_user_admin'
  end
end
