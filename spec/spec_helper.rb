ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require_relative 'support/cms'
require_relative 'support/contain_article_label_matcher'
require 'mas/development_dependencies/rspec/spec_helper'
