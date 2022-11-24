source 'https://rubygems.org'
source 'https://gem.fury.io/benlovell'

ruby File.read('.ruby-version', &:readline)

gem 'active_model_serializers', '~> 0.9.0'
gem 'addressable', '~> 2.5'
gem 'algoliasearch'
gem 'apipie-rails', '~> 0.5.6'
gem 'autoprefixer-rails', '~> 5.0.0.1'
gem 'azure', '0.7.10'
gem 'bowndler', '~> 1.0'
gem 'bugsnag'
gem 'clockwork'
gem 'coffee-rails', '~> 4.0.0'
gem 'comfortable_mexican_sofa', '2.2.0', source: 'https://gem.fury.io/benlovell'
gem 'devise', '~> 4.6.0'
gem 'dough-ruby', '~> 5.0', git: 'https://github.com/moneyadviceservice/dough.git'
gem 'feature'
gem 'google-api-client', '0.7.1'
gem 'httparty', '~> 0.13.7'
gem 'jbuilder', '~> 2.0'
# See: https://github.com/comfy/comfortable-mexican-sofa/issues/486
# Used in comfy. pegging version fixes asset pipeline error.
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0'
gem 'legato', '0.4.0'
gem 'mailjet'
gem 'mastalk', '~> 0.10.0'
gem 'mysql2', '~> 0.3.18'
gem 'newrelic_rpm'
gem 'nokogiri', '1.10.1'
gem 'oauth2', '1.0.0'
gem 'paper_trail'
gem 'paperclip-azure', '~> 0.2'
gem 'preamble', '0.0.3'
gem 'rails', '4.2.11.1'
gem 'remotipart', '~> 1.2'
gem 'responders', '~> 2.0'
gem 'reverse_markdown'
gem 'sass-rails', '~> 4.0.3'
gem 'terminal-table'
gem 'uglifier', '>= 1.3.0'
gem 'whenever', require: false
gem 'word-to-markdown', git: 'https://github.com/moneyadviceservice/word-to-markdown.git'
gem 'xmlrpc'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'seedbank'
  gem 'spring'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rspec'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'aruba', '~> 0.14.5'
  gem 'cucumber-rails', '~> 1.4.3', require: false
  gem 'database_cleaner'
  gem 'poltergeist', '~> 1.3'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers'
  gem 'site_prism'
  gem 'vcr'
  gem 'webmock', '~> 2.3.1'
end

group :test, :development do
  gem 'brakeman', require: false
  # temporarily pin capybara, the following breaks Rake:
  # https://github.com/jnicklas/capybara/commit/385a7507f6525d9b2d1e23bef0bb2e6fe5ad0c97
  gem 'capybara'
  gem 'danger', require: false
  gem 'danger-rubocop', require: false
  gem 'dotenv-rails'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'launchy'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.8.0'
  gem 'rubocop', '~> 0.59', require: false
  gem 'ruby-prof', require: false
  gem 'timecop'
  gem 'tzinfo-data'
  gem 'valid_attribute', require: false
end

group :development, :production do
  gem 'unicorn-rails'
end

group :production do
  gem 'syslog-logger'
end
