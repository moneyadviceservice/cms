require_relative '../cms/hippo_import'

namespace :cms do
  namespace :hippo do
    desc 'Import Hippo XML data into database (options: FROM=folder_name TO=site_identifier DOCS=file_of_docs)'
    task import: :environment do
      from  = ENV['FROM']
      to    = ENV['TO']
      docs  = ENV['DOCS']

      puts "Importing CMS Data from file [#{from}]..."

      file = File.read(File.expand_path(from))
      docs = File.read(File.expand_path(docs)).split("\n") if docs

      imported = HippoImport.new(file, docs, to).import!

      puts "Imported #{imported.size} articles."
    end
  end
end
