ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require_relative 'support/cms'
require 'mas/development_dependencies/rspec/spec_helper'
