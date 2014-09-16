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

gem 'word-to-markdown', :git => 'https://github.com/moneyadviceservice/word-to-markdown.git'

# Used in comfy. pegging version fixes asset pipeline error.
# See: https://github.com/comfy/comfortable-mexican-sofa/issues/486
gem 'jquery-ui-rails', '~> 5.0'

gem 'dough-ruby', '~> 3.0', :git => 'https://github.com/moneyadviceservice/dough.git'
gem 'bowndler', :git => 'git@github.com:moneyadviceservice/bowndler'

group :development do
  gem 'spring'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'rspec_junit_formatter'
end

group :test, :development do
  gem 'mas-development_dependencies',
      git: 'https://github.com/moneyadviceservice/mas-development_dependencies.git'
  gem 'rspec-rails', '~> 3.0'
  gem 'pry-rails'
end

group :production do
  gem 'syslog-logger'
  gem 'unicorn-rails'
end
