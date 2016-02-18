module Cms
  class LayoutBuilder
    def self.add_home_page!
      Comfy::Cms::Layout.create!(
        site: english_site,
        label: 'Home Page',
        identifier: 'home_page',
        content: home_page_content
      )

      welsh_layout = welsh_site.layouts.find_by(identifier: 'home_page')
      welsh_layout.update_attributes!(content: home_page_content)
    end

    def self.add_contact_panels!
      Comfy::Cms::Layout.create!(
        site: english_site,
        label: 'Contact Panels',
        identifier: 'contact_panels',
        content: '{{ cms:page:web_chat_times }}'
      )

      welsh_layout = welsh_site.layouts.find_by(identifier: 'contact_panels')
      welsh_layout.update_attributes!(content: '{{ cms:page:web_chat_times }}')
    end

    def self.english_site
      Comfy::Cms::Site.find_by(label: 'en')
    end

    def self.welsh_site
      Comfy::Cms::Site.find_by(label: 'cy')
    end

    # rubocop:disable Metrics/MethodLength
    def self.home_page_content
      <<-CONTENT
        {{ cms:page:raw_heading:string }}
        {{ cms:page:raw_hero_image:image }}
        {{ cms:page:raw_bullet_1:string }}
        {{ cms:page:raw_bullet_2:string }}
        {{ cms:page:raw_bullet_3:string }}
        {{ cms:page:raw_cta_text:string }}
        {{ cms:page:raw_cta_link:string }}

        {{ cms:field:raw_tool_1_heading }}
        {{ cms:field:raw_tool_1_url }}
        {{ cms:page:raw_tool_1_text }}

        {{ cms:field:raw_tool_2_heading }}
        {{ cms:field:raw_tool_2_url }}
        {{ cms:page:raw_tool_2_text }}

        {{ cms:field:raw_tool_3_heading }}
        {{ cms:field:raw_tool_3_url }}
        {{ cms:page:raw_tool_3_text }}

        {{ cms:field:raw_tile_1_heading }}
        {{ cms:page:raw_tile_1_image:image }}
        {{ cms:field:raw_tile_1_url }}
        {{ cms:field:raw_tile_1_label }}
        {{ cms:page:raw_tile_1_content }}

        {{ cms:field:raw_tile_2_heading }}
        {{ cms:page:raw_tile_2_image:image }}
        {{ cms:field:raw_tile_2_url }}
        {{ cms:field:raw_tile_2_label }}
        {{ cms:page:raw_tile_2_content }}

        {{ cms:field:raw_tile_3_heading }}
        {{ cms:page:raw_tile_3_image:image }}
        {{ cms:field:raw_tile_3_url }}
        {{ cms:field:raw_tile_3_label }}
        {{ cms:page:raw_tile_3_content }}

        {{ cms:field:raw_tile_4_heading }}
        {{ cms:page:raw_tile_4_image:image }}
        {{ cms:field:raw_tile_4_url }}
        {{ cms:field:raw_tile_4_label }}
        {{ cms:page:raw_tile_4_content }}

        {{ cms:field:raw_text_tile_1_heading }}
        {{ cms:field:raw_text_tile_1_url }}
        {{ cms:page:raw_text_tile_1_content }}

        {{ cms:field:raw_text_tile_2_heading }}
        {{ cms:field:raw_text_tile_2_url }}
        {{ cms:page:raw_text_tile_2_content }}

        {{ cms:field:raw_promo_banner_content }}
        {{ cms:field:raw_promo_banner_url }}
      CONTENT
    end
  end
end
