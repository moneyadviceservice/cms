namespace :redirects do
  desc 'delete all redirects'
  task delete_all: :environment do
    Redirect.delete_all
  end

  desc 'import redirects from a json manifest'
  task :import, [:path] => :environment do |task, args|
    importer = RedirectImporter.new(args.path)
    importer.import!
  end
end
