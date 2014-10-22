Given(/^I am logged in$/) do
  @current_user = Comfy::Cms::User.create!(:email => 'user@test.com', :password => 'password')
  login_as(@current_user, :scope => :user)
end
