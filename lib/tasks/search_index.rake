namespace :search do
  desc 'Index CMS database'
  task index: :environment do
    adapter = ENV.fetch('INDEXERS_ADAPTER')
    ::IndexDatabaseTask.new(adapter).run
  end
end
