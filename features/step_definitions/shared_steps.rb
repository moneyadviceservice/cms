Given(/^I am logged in$/) do
  email = 'testing@man.net'
  password = 'secretpass'
  user = Comfy::Cms::User.new(:email => email, :password => password, :password_confirmation => password).save!
  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log in"
end
