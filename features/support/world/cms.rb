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
      self.layout ||= cms_site(locale).layouts.create!(
        identifier: 'article',
        content: '{{ cms:page:content:rich_text }}'
      )
    end

    def cms_root(locale='en')
      self.root ||= cms_site(locale).pages.create!(layout: cms_layout, label: 'root')
      self.root
    end

    def cms_categories
      self.categories ||= [create(:category, site: cms_site, label: identifier)]
      self.categories << create(:category, site: cms_site, label: identifier) unless self.categories.length > 1
      self.categories
    end

    def cms_page(published: true, locale: 'en', label: identifier())
      @cms_page ||= build_cms_page(
        published: published,
        locale: locale,
        label: label
      )
    end

    def build_cms_page(page: nil, published: true, locale: 'en', label: identifier())
      page ||= cms_site(locale).pages.create!(
        parent: cms_root(locale),
        layout: cms_layout(locale),
        label: label,
        slug: label.parameterize
      )
      page.blocks.create!(
        identifier: 'content',
        content: 'test'
      ) if page.blocks.empty?
      page.update_columns(is_published: published)
      page
    end

    def cms_new_unsaved_page
      build_cms_new_unsaved_page(page: cms_page)
    end

    def build_cms_new_unsaved_page(page: nil)
      page ||= build_cms_page
      page.save!
      page
    end

    def cms_new_draft_page(label: identifier(), locale: 'en')
      build_cms_new_draft_page(page: cms_page)
    end

    def build_cms_new_draft_page(page: nil, label: identifier(), locale: 'en')
      page ||= build_cms_page(label: label, locale: locale)
      page.create_initial_draft
      PageBlocksRegister.new(
        page,
        author: set_current_user,
        new_blocks_attributes: page.blocks_attributes
      ).save!
      page
    end

    def cms_published_page(label: identifier(), locale: 'en')
      build_cms_published_page(
        page: cms_new_draft_page,
        label: label,
        locale: locale
      )
    end

    def build_cms_published_page(page: nil, label: identifier(), locale: 'en')
      page ||= build_cms_new_draft_page(label: label, locale: locale)

      page.publish
      PageBlocksRegister.new(
        page,
        author: set_current_user,
        new_blocks_attributes: page.blocks_attributes
      ).save!

      page
    end

    def cms_draft_version_of_page
      build_cms_draft_version_of_page(page: cms_published_page)
    end

    def build_cms_draft_version_of_page(page: nil)
      page ||= build_cms_published_page

      page.create_new_draft
      AlternatePageBlocksRegister.new(
        page,
        author: set_current_user,
        new_blocks_attributes: page.blocks_attributes
      ).save!
      page
    end

    def cms_scheduled_page(live: false, label: identifier(), locale: 'en')
      build_cms_scheduled_page(
        page: cms_new_draft_page,
        live: live,
        label: label,
        locale: locale
      )
    end

    def build_cms_scheduled_page(page: nil, live: false, label: identifier(), locale: 'en')
      page ||= build_cms_new_draft_page(label: label, locale: locale)

      page.schedule
      page.scheduled_on = live ? 1.minute.ago : 1.minute.from_now
      PageBlocksRegister.new(
        page,
        author: set_current_user,
        new_blocks_attributes: page.blocks_attributes
      ).save!
      page
    end

    def cms_scheduled_new_version_of_page(live: false)
      build_cms_scheduled_new_version_of_page(
        page: cms_published_page,
        live: live
      )
    end

    def build_cms_scheduled_new_version_of_page(page: nil, live: false)
      page ||= build_cms_published_page(live: live)

      page.create_new_draft
      AlternatePageBlocksRegister.new(
        page,
        author: set_current_user,
        new_blocks_attributes: page.blocks_attributes
      ).save!

      page.schedule
      page.scheduled_on = 1.minute.from_now
      AlternatePageBlocksRegister.new(
        page,
        author: set_current_user,
        new_blocks_attributes: page.blocks_attributes
      ).save!

      page.update_column(:scheduled_on, 1.minute.ago) if live == true
      page
    end

    def set_current_user(email: 'user@test.com', password: 'password')
      @current_user ||= Comfy::Cms::User.create_with(password: password).find_or_create_by!(email: email, role: Comfy::Cms::User.roles[:admin])
    end

    def log_me_in!(user = set_current_user)
      login_as(user, scope: :user)
    end

    def load_page_in_editor(page: cms_page, site: cms_site)
      log_me_in!
      edit_page.load(site: site.id, page: page.id)
      wait_for_page_load
      page
    end

    def load_alternate_page_in_editor(page: cms_page, site: cms_site)
      log_me_in!
      alternate_edit_page.load(site: cms_site.id, page: page.id)
    end

    private

    def identifier
      [*('A'..'Z')].sample(8).join
    end

  end
end

World(World::Cms)
