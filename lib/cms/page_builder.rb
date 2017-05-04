module Cms
  class PageBuilder
    def self.add_example_article!
      site   = Comfy::Cms::Site.find_by(label: 'en')
      layout = site.layouts.find_by(identifier: 'article')
      Comfy::Cms::Page.create!(slug: 'example-article', site: site, layout: layout)
    end

    def self.add_home_page!
      site   = Comfy::Cms::Site.find_by(label: 'en')
      layout = site.layouts.find_by(identifier: 'home_page')

      page = Comfy::Cms::Page.create!(slug: 'the-money-advice-service', site: site, layout: layout)

      content_areas = layout.content.scan(/{{\s*\w+\:\w+\:(\w+)/).map(&:first)
      content_areas.each do |content_area|
        page.blocks.create!(identifier: content_area, content: '')
      end

      page.create_initial_draft!
      page.publish!
    end

    def self.add_footer!
      create_page('footer')
    end

    def self.add_offline_page!
      create_page('offline_page')
    end

    def self.create_page(identifier)
      layout       = english_site.layouts.find_by(identifier: identifier)
      english_page = Comfy::Cms::Page.create!(slug: identifier, site: english_site, layout: layout)
      welsh_page   = welsh_site.pages.find_by(slug: identifier)

      create_page_blocks layout, [english_page, welsh_page]
      publish_pages [english_page, welsh_page]
    end


    def self.english_site
      Comfy::Cms::Site.find_by(label: 'en')
    end

    def self.welsh_site
      Comfy::Cms::Site.find_by(label: 'cy')
    end

    def self.create_page_blocks(layout, pages)
      content_areas = layout.content.scan(/{{\s*\w+\:\w+\:(\w+)/).map(&:first)
      content_areas.each do |content_area|
        pages.each { |page| page.blocks.create!(identifier: content_area, content: '') }
      end
    end

    def self.publish_pages(pages)
      pages.each do |page|
        page.create_initial_draft!
        page.publish!
      end
    end
  end
end
