namespace :adhoc do
  desc 'Extract a list of All articles and what categories they sit in'
  task :extract_page => :environment do
    File.open('pages_with_cat.csv','w') do |file|
      file.write "Url\tCategories\n"
      Comfy::Cms::Page.where(state: :published).find_each do |page|
        file.write "/en/articles/#{page.slug}\t#{page.categories.map(&:label).join(', ')}\n"
        $stdout.write '.'
      end
      puts "\nCreated csv file `#{file.path}`"
      file.flush
    end
  end
end
