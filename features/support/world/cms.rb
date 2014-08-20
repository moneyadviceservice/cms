module World
  module Cms
    attr_accessor :site, :layout, :root, :page, :categories

    def cms_site
      self.site ||= Comfy::Cms::Site.create(identifier: identifier)
    end

    def cms_layout
      self.layout ||= cms_site.layouts.create(identifier: identifier, content: '{{ cms:page:content:rich_text }}')
    end

    def cms_root
      self.root ||= cms_site.pages.create(layout: cms_layout, label: 'root')
    end

    def cms_categories
      self.categories ||= [cms_site.categories.create(label: identifier, categorized_type: "Comfy::Cms::Page")]
      self.categories << cms_site.categories.create(label: identifier, categorized_type: "Comfy::Cms::Page") unless self.categories.length > 1
      self.categories
    end

    def cms_page(published: true)
      self.page ||= cms_site.pages.create(parent: cms_root, layout: cms_layout, label: identifier, slug: identifier.downcase)
      self.page.blocks.create(identifier: 'content', content: 'test') if self.page.blocks.empty?
      self.page.update_columns(is_published: published)
      self.page
    end

    private

    def identifier
      [*('A'..'Z')].sample(8).join
    end

  end
end

World(World::Cms)
