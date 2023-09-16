ENV['RAILS_ENV']  = 'test'
ENV['RAILS_ROOT'] = File.expand_path('../../../', __FILE__)

require 'cucumber/rails'
require 'capybara/rails'
require 'aruba/cucumber'
require 'database_cleaner/cucumber'
require 'selenium/webdriver'

DatabaseCleaner.strategy = :truncation

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w(headless no-sandbox disable-gpu window-size=2500,2500)
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :chrome_headless
Capybara.default_max_wait_time = 30

Capybara.ignore_hidden_elements = false

World(FactoryGirl::Syntax::Methods)

Aruba.configure do |config|
  config.command_runtime_environment = { 'INDEXERS_ADAPTER' => 'local' }
end

