ENV['RAILS_ENV']  = 'test'
ENV['RAILS_ROOT'] = File.expand_path('../../../', __FILE__)

require 'cucumber/rails'
require 'capybara/rails'
require 'capybara/poltergeist'

Cucumber::Rails::Database.javascript_strategy = :truncation

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: true, inspector: true, window_size: [2048, 1536])
end

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 20

Capybara.ignore_hidden_elements = false

World(FactoryGirl::Syntax::Methods)
