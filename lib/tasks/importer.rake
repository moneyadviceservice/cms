require_relative '../cms/hippo_import'

namespace :cms do
  namespace :hippo do
    desc 'Import Hippo XML data into database (options: FROM=folder_name TO=site_identifier)'

    task :import => :environment do
      from  = ENV['FROM']
      to    = ENV['TO']

      puts "Importing CMS Data from file [#{from}]..."

      file = File.read(File.expand_path(from))

      imported = HippoImport.new(file, to).import!

      puts "Imported #{imported.size} articles."
    end
  end
end
