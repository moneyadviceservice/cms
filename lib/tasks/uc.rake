namespace :uc do
  desc 'Add universal credit content to CMS database'
  task :add_pages, [:layout, :path]  => :environment do |t, args|
    save_page = lambda do |page, object|
      fail("Missing .md file for page #{page}") unless object

      page.slug = object.slug
      puts '*' * 80
      puts "Creating page #{page.slug} id:#{page.id}"
      puts '*' * 80
      page.blocks.delete_all
      page.blocks.new(identifier: 'content', content: object.content)
      page.state = 'published'
      page.save!
      page
    end

    load_preamble = lambda do |path|
      puts "Trying to load file #{path}"
      if File.exist?(path)
        preamble = Preamble.load(path)
        fail("Md file #{path} is missing slug ") if preamble.metadata['slug'].blank?
        OpenStruct.new(slug:    preamble.metadata['slug'].slugify,
                       content: preamble.content)
      else
        puts "Could not find file #{path}"
      end
    end

    path = args[:path] || 'vendor/universal_credit/en'
    layout = args[:layout] || 'universal_credit'

    puts
    puts '*' * 80
    puts "***   Going to create #{layout} pages from #{path}"
    puts '*' * 80
    sleep 2

    dir_path = File.join(Rails.root, path)
    en_site = Comfy::Cms::Site.find_by(label: 'en')
    en_uc_layout = en_site.layouts.find_by(identifier: layout)

    puts "Empty folder #{dir_path}" if Dir["#{dir_path}/*.md"].empty?
    Dir["#{dir_path}/*.md"].each do |en_file|
      object = load_preamble[en_file]
      english_page = en_site.pages.find_or_initialize_by(slug: object.slug, layout: en_uc_layout)
      save_page[english_page, object]

      welsh_page = english_page.mirrors.find { |mirror| mirror.site.label == 'cy' }
      ab = load_preamble[en_file.sub('/en/', '/cy/')]
      save_page[welsh_page, ab]
    end

  end
end
