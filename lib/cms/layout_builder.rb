module Cms
  class LayoutBuilder
    def self.add_home_page!
      add_layout!(
        label: 'Home Page',
        identifier: 'home_page',
        content: home_page_content,
        en_site: english_site,
        cy_site: welsh_site
      )
    end

    def self.add_footer!
      add_layout!(
        label: 'Footer',
        identifier: 'footer',
        content: footer_content,
        en_site: english_site,
        cy_site: welsh_site
      )
    end

    def self.add_layout!(label:, identifier:, content:, en_site:, cy_site:)
      Comfy::Cms::Layout.create!(
        site: en_site,
        label: label,
        identifier: identifier,
        content: content
      )

      welsh_layout = cy_site.layouts.find_by(identifier: identifier)
      welsh_layout.update_attributes!(content: content)
    end

    def self.english_site
      Comfy::Cms::Site.find_by(label: 'en')
    end

    def self.welsh_site
      Comfy::Cms::Site.find_by(label: 'cy')
    end

    def self.footer_content # rubocop:disable Metrics/MethodLength
      <<-CONTENT
        {{ cms:page:raw_web_chat_heading:string }}
        {{ cms:page:raw_web_chat_additional_one:string }}
        {{ cms:page:raw_web_chat_additional_two:string }}
        {{ cms:page:raw_web_chat_additional_three:string }}
        {{ cms:page:raw_web_chat_small_print:string }}

        {{ cms:page:raw_contact_heading:string }}
        {{ cms:page:raw_contact_introduction:string }}
        {{ cms:page:raw_contact_phone_number:string }}
        {{ cms:page:raw_contact_additional_one:string }}
        {{ cms:page:raw_contact_additional_two:string }}
        {{ cms:page:raw_contact_additional_three:string }}
        {{ cms:page:raw_contact_small_print:string }}
      CONTENT
    end

    def self.home_page_content # rubocop:disable Metrics/MethodLength
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
