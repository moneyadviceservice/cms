When(/^I visit the user management page$/) do
  cms_site
  cms_layout
  step('I am logged in')
  user_management_page.load
end

When(/^I add a new user$/) do
  user_management_page.new_user.click
  user_management_page.user_name.set('Test Tester')
  user_management_page.user_email.set('test@tester.com')
  user_management_page.user_password.set('password')
  user_management_page.create_user.click
  expect(page.has_content?('Test Tester')).to be(true)
  expect(page.has_content?('test@tester.com')).to be(true)
end

When(/^I delete the new user$/) do
  user_management_page.delete_user.last.click
end

When(/^I sign out and back in$/) do
  step('I sign out')
  step('I sign in')
end

When(/^I sign out$/) do
  click_link 'Sign out'
end

When(/^I sign in$/) do
  sign_in_page.load
  sign_in_page.email.set('test@tester.com')
  sign_in_page.password.set('password')
  sign_in_page.log_in.click
end

Then(/^the new user should be able to log in$/) do
  step('I sign out and back in')
  expect(page).to have_content('Signed in successfully.')
end

Then(/^the new user should not be able to log in$/) do
  step('I sign out and back in')
  expect(page).to_not have_content('Signed in successfully.')
end

Given(/^I am (?:a normal|not an admin) user$/) do
  @current_user = FactoryGirl.create(:user,
                                     role: Comfy::Cms::User.roles[:user],
                                     email: 'test@tester.com',
                                     password: 'password',
                                     password_confirmation: 'password'
                                    )
end

Given(/^I am an admin user$/) do
  @current_user = FactoryGirl.create(:user,
                                     role: Comfy::Cms::User.roles[:admin],
                                     email: 'test@tester.com',
                                     password: 'password',
                                     password_confirmation: 'password'
                                    )
end

Given(/^I am an editor user$/) do
  @current_user = FactoryGirl.create(:user,
                                     role: Comfy::Cms::User.roles[:editor],
                                     email: 'test@tester.com',
                                     password: 'password',
                                     password_confirmation: 'password'
                                    )
end

Then(/^I should not be able to visit the user management page$/) do
  step('I visit the user management page')
  expect(page).to_not have_content('Users')
end

When(/^I go to my profile page$/) do
  edit_user_page.load(user_id: @current_user.id)
end

When(/^I should be able to see my profile$/) do
  expect(page).to have_content('Name')
  expect(page).to have_content('Email')
  expect(page).to have_content('Password')
  expect(page).to_not have_content('Admin')
end
