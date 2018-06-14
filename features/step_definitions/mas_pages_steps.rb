Given(/^I have a home page layout setup with components$/) do
  step('setup basic layout')
  step('setup homepage')
end

Given(/^I have a footer layout setup with components$/) do
  step('setup basic layout')
  step('setup footer')
end

Given(/^setup homepage$/) do
  cms_site.layouts.find_or_create_by(
    label: 'Home Page',
    identifier: 'home_page',
    content:  <<-CONTENT
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
  )
end

Given(/^setup footer$/) do
  cms_site.layouts.find_or_create_by(
    label: 'Footer',
    identifier: 'footer',
    content:  <<-CONTENT
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
  )
end

Given(/^setup basic layout$/) do
  cms_site.layouts.find_or_create_by(
    label: 'Basic',
    identifier: 'basic',
    content:  <<-CONTENT
      {{ cms:page:content:rich_text }}
    CONTENT
  )
end
