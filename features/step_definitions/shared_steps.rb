Given(/^I am logged in$/) do
  log_me_in!
end

When(/^I log in$/) do
  set_current_user
  fill_in 'user_email',    with: 'user@test.com'
  fill_in 'user_password', with: 'password'
  click_button 'Log in'
end

def loging_in_user(&block)
  cms_site
  cms_layout
  step("I am logged in")
  block.call
  step('I log in') if page.current_path == '/users/sign_in'
  define_bind rescue nil
  wait_for_ajax_complete
end
