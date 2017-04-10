namespace :uc do
  desc 'Add universal credit content to CMS database'
  task :add_pages, [:dir_path] => :environment do |t, args|
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    save_page = lambda do |page, object|
      page.slug = object.title
      puts '*' * 80
      puts "Creating page #{page.slug}"
      puts '*' * 80
      page.blocks.delete_all
      page.blocks.new(identifier: 'content', content: object.content)
      page.state = 'published'
      page.save!
      page
    end

    load_preamble = lambda do |path|
      if File.exist?(path)
        preamble = Preamble.load(path)
        OpenStruct.new(title: preamble.metadata['title'].downcase.slugify,
                       content: preamble.content)
      else
        puts "Could not find file #{path}"
      end
    end


    dir_path = File.expand_path(args[:dir_path])
    en_site = Comfy::Cms::Site.find_by(label: 'en')
    en_uc_layout = en_site.layouts.find_by(identifier: 'universal_credit')

    Dir["#{dir_path}/*.md"].each do |en_file|
      object = load_preamble[en_file]
      page = en_site.pages.find_or_initialize_by(slug: object.title, layout: en_uc_layout)
      save_page[page, object] # save english page

      welsh_page = page.mirrors.find { |mirror| mirror.site.label == 'cy' }
      ab = load_preamble[en_file.sub('/en/', '/cy/')]
      save_page[welsh_page, ab] if ab # save welsh page
    end

  end
end
