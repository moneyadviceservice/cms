source 'http://gems.test.mas'
source 'https://rubygems.org'

gem 'rails', '4.1.1'
gem 'sqlite3'
gem 'mysql2'
gem 'sass-rails', '~> 4.0.3'
gem 'autoprefixer-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'dotenv-rails'

gem 'comfortable_mexican_sofa', '~>1.12.1.0'

gem 'word-to-markdown', git: 'https://github.com/moneyadviceservice/word-to-markdown.git'

# Used in comfy. pegging version fixes asset pipeline error.
# See: https://github.com/comfy/comfortable-mexican-sofa/issues/486
gem 'jquery-ui-rails', '~> 5.0'

gem 'dough-ruby', '~> 4.0', git: 'https://github.com/moneyadviceservice/dough.git'
gem 'bowndler', git: 'git@github.com:moneyadviceservice/bowndler'

gem 'hippo_xml_parser', git: 'git@github.com:moneyadviceservice/hippo_xml_parser'

gem 'remotipart', '~> 1.2'
gem 'devise'

gem 'reverse_markdown'
gem 'active_model_serializers'

gem 'oauth2', '1.0.0'
gem 'google-api-client', '0.7.1'
gem 'legato', '0.4.0'

group :development do
  gem 'spring'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'rspec_junit_formatter'
end

group :test, :development do
  gem 'byebug'
  # temporarily pin capybara, the following breaks Rake:
  # https://github.com/jnicklas/capybara/commit/385a7507f6525d9b2d1e23bef0bb2e6fe5ad0c97
  gem 'capybara', '2.4.1'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'mas-development_dependencies',
      git: 'https://github.com/moneyadviceservice/mas-development_dependencies.git'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.0'
  gem 'rubocop', require: false
end

group :production do
  gem 'syslog-logger'
  gem 'unicorn-rails'
end
