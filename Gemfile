source 'http://gems.dev.mas.local'
source 'https://rubygems.org'

gem 'active_model_serializers'
gem 'autoprefixer-rails'
gem 'azure', '0.7.7'
gem 'bowndler', git: 'git@github.com:moneyadviceservice/bowndler'
gem 'bugsnag'
gem 'clockwork'
gem 'coffee-rails', '~> 4.0.0'
gem 'comfortable_mexican_sofa', '2.0.1.79.79', source: 'http://gems.dev.mas.local'
gem 'devise'
gem 'dough-ruby', '~> 5.0', git: 'https://github.com/moneyadviceservice/dough.git'
gem 'feature'
gem 'fog'
gem 'google-api-client', '0.7.1'
gem 'httparty', '~> 0.13.7'
gem 'jbuilder', '~> 2.0'
# Used in comfy. pegging version fixes asset pipeline error.
# See: https://github.com/comfy/comfortable-mexican-sofa/issues/486
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0'
gem 'legato', '0.4.0'
gem 'mailjet'
gem 'mastalk', '0.9.0'
gem 'mysql2'
gem 'newrelic_rpm'
gem 'oauth2', '1.0.0'
gem 'paper_trail'
gem 'paperclip-azure', '~> 0.2'
gem 'preamble', '0.0.3'
gem 'rails', '4.1.16'
gem 'remotipart', '~> 1.2'
gem 'reverse_markdown'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'word-to-markdown', git: 'https://github.com/moneyadviceservice/word-to-markdown.git'

group :development do
  gem 'spring'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rspec'
  gem 'terminal-table'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'unicorn-rails'
end

group :test do
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers'
  gem 'cucumber-rails', require: false
  gem 'site_prism'
  gem 'database_cleaner'
  gem 'poltergeist', '~> 1.3'
  gem 'vcr'
  gem 'webmock'
end

group :test, :development do
  # temporarily pin capybara, the following breaks Rake:
  # https://github.com/jnicklas/capybara/commit/385a7507f6525d9b2d1e23bef0bb2e6fe5ad0c97
  gem 'capybara', '2.4.1'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.0'
  gem 'rubocop', require: false
  gem 'valid_attribute', require: false
  gem 'dotenv-rails'
  gem 'launchy'
  gem 'ruby-prof', require: false
end

group :production do
  gem 'syslog-logger'
  gem 'unicorn-rails'
end
