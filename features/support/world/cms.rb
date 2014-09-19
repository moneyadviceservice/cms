module World
  module Cms
    attr_accessor :layout, :root, :a_page, :categories, :site

    def cms_site(locale="en")
      self.site ||= {}
      self.site[locale] ||= Comfy::Cms::Site.create!(identifier: locale, label: locale, is_mirrored: true)
    end

    def cms_sites
      cms_site("en")
      cms_site("cy")
    end

    def cms_layout(locale='en')
      self.layout ||= cms_site(locale).layouts.create!(identifier: identifier, content: '{{ cms:page:content:rich_text }}')
    end

    def cms_root(locale='en')
      self.root ||= cms_site(locale).pages.create!(layout: cms_layout, label: 'root')
    end

    def cms_categories
      self.categories ||= [cms_site.categories.create!(label: identifier, categorized_type: "Comfy::Cms::Page")]
      self.categories << cms_site.categories.create!(label: identifier, categorized_type: "Comfy::Cms::Page") unless self.categories.length > 1
      self.categories
    end

    def cms_page(published: true, locale: "en")
      self.a_page ||= {}
      self.a_page[locale] ||= cms_site(locale).pages.create!(parent: cms_root(locale), layout: cms_layout(locale), label: identifier, slug: identifier.downcase)
      self.a_page[locale].blocks.create!(identifier: 'content', content: 'test') if self.a_page[locale].blocks.empty?
      self.a_page[locale].update_columns(is_published: published)
      self.a_page[locale]
    end

    private

    def identifier
      [*('A'..'Z')].sample(8).join
    end

  end
end

World(World::Cms)
