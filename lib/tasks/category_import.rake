require_relative '../cms/category_import'
require_relative '../cms/page_category_order'

namespace :category do
  desc 'Create layouts'
  task import: :environment do
    CategoryImport.new.import!
  end

  task order: :environment do
    PageCategoryOrder.new.call
  end
end
