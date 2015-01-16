namespace :cms do
  namespace :hippo do
    desc 'Import Hippo XML data into database \n(options: FROM=folder_name TO=site_identifier DOCS=file_of_docs TYPE=type)'
    task import: :environment do
      from  = ENV['FROM']
      to    = ENV['TO']
      docs  = ENV['DOCS']
      type  = ENV.fetch('type', 'base')

      puts "Importing CMS Data from file [#{from}]..."

      file = File.read(File.expand_path(from))
      docs = File.read(File.expand_path(docs)).split("\n") if docs

      import = "Cms::HippoImporter::#{type.classify}".constantize.new(data: file, docs: docs, to: to)
      imported = import.import!

      puts "Imported #{imported.size} articles."
    end
  end
end
