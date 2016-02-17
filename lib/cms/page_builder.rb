module Cms
  class PageBuilder
    def self.add_home_page!
      site   = Comfy::Cms::Site.find_by(label: 'en')
      layout = site.layouts.find_by(identifier: 'home_page')

      page = Comfy::Cms::Page.create!(slug: 'the-money-advice-service', site: site, layout: layout)

      content_areas = layout.content.scan(/{{\s*\w+\:\w+\:(\w+)/).map(&:first)
      content_areas.each do |content_area|
        page.blocks.create!(identifier: content_area, content: '')
      end

      page.save_unsaved!
      page.publish!
    end
  end
end
