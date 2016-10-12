namespace :adhoc do
  desc 'Extract a list of All articles and what categories they sit in'
  task :extract_page => :environment do
    File.open('pages_with_cat.csv','w') do |file|
      file.write "Url\tCategories\n"
      if en = Comfy::Cms::Site.find_by(label: :en)
        en.pages.published.find_each do |page|
          file.write "/en/articles/#{page.slug}\t#{page.categories.map(&:label).join(', ')}\n"
          $stdout.write '.'
        end
        puts "\nCreated csv file `#{file.path}`"
        file.flush
      else
        puts 'No english site'
      end
    end
  end
end
