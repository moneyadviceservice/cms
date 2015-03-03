require_relative '../cms/category_locale_migration'

namespace :category_locale do
  desc 'Migrate welsh categories to engligh'
  task migrate: :environment do
    CategoryLocaleMigration.new.call
  end

  desc 'Delete old welsh categories'
  task delete: :environment do
    CategoryLocaleMigration.new.delete!
  end
end
