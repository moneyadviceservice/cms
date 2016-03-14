module World
  module Cms
    attr_accessor :layout, :root, :a_page, :categories, :site

    def cms_site(locale="en")
      self.site ||= {}
      self.site[locale] ||= Comfy::Cms::Site.create!(identifier: locale, label: locale, is_mirrored: true, path: locale)
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
      self.categories ||= [create(:category, site: cms_site, label: identifier)]
      self.categories << create(:category, site: cms_site, label: identifier) unless self.categories.length > 1
      self.categories
    end

    def cms_page(published: true, locale: "en")
      self.a_page ||= {}
      self.a_page[locale] ||= cms_site(locale).pages.create!(parent: cms_root(locale), layout: cms_layout(locale), label: identifier, slug: identifier.downcase)
      self.a_page[locale].blocks.create!(identifier: 'content', content: 'test') if self.a_page[locale].blocks.empty?
      self.a_page[locale].update_columns(is_published: published)
      self.a_page[locale]
    end

    def cms_new_unsaved_page
      cms_site
      cms_page.save!
      log_me_in!
      cms_page
    end

    def cms_new_draft_page
      cms_site
      cms_page.create_initial_draft
      PageBlocksRegister.new(cms_page, author: set_current_user, new_blocks_attributes: cms_page.blocks_attributes).save!

      log_me_in!
      cms_page
    end

    def cms_published_page
      cms_new_draft_page

      cms_page.publish
      PageBlocksRegister.new(cms_page, author: set_current_user, new_blocks_attributes: cms_page.blocks_attributes).save!

      cms_page
    end

    def cms_draft_version_of_page
      cms_published_page

      cms_page.create_new_draft
      AlternatePageBlocksRegister.new(cms_page, author: set_current_user, new_blocks_attributes: cms_page.blocks_attributes).save!

      log_me_in!
      cms_page
    end

    def cms_scheduled_page(live = false)
      cms_new_draft_page

      cms_page.schedule
      cms_page.scheduled_on = live ? 1.minute.ago : 1.minute.from_now
      PageBlocksRegister.new(cms_page, author: set_current_user, new_blocks_attributes: cms_page.blocks_attributes).save!

      log_me_in!
      cms_page
    end

    def cms_scheduled_new_version_of_page(live = false)
      cms_published_page

      cms_page.create_new_draft
      AlternatePageBlocksRegister.new(cms_page, author: set_current_user, new_blocks_attributes: cms_page.blocks_attributes).save!

      cms_page.schedule
      cms_page.scheduled_on = 1.minute.from_now
      AlternatePageBlocksRegister.new(cms_page, author: set_current_user, new_blocks_attributes: cms_page.blocks_attributes).save!

      cms_page.update_column(:scheduled_on, 1.minute.ago) if live == true

      log_me_in!
      cms_page
    end

    def set_current_user(email: 'user@test.com', password: 'password')
      @current_user ||= Comfy::Cms::User.create_with(password: password).find_or_create_by!(email: email, role: Comfy::Cms::User.roles[:admin])
    end

    def log_me_in!(user = set_current_user)
      login_as(user, scope: :user)
    end

    private

    def identifier
      [*('A'..'Z')].sample(8).join
    end

  end
end

World(World::Cms)
