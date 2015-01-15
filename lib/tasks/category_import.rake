require_relative '../cms/category_import'

namespace :category do
  desc 'Create layouts'
  task import: :environment do
    CategoryImport.new.import!
  end
end
