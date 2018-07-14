english_site = Comfy::Cms::Site.find_or_create_by(
  label: 'en',
  identifier: 'money-advice-service-en',
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: 'en',
  locale: 'en',
  is_mirrored: true
)

thematic_review_layout = english_site.layouts.find_or_create_by(
  identifier: 'thematic_review',
  label: 'Thematic Review',
  content:  <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:overview }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:page:cta_links:simple_component/[Text Link](/en/evidence_hub?tag=something) }}
    {{ cms:page:download:simple_component/[Text Link](link) }}
    {{ cms:page:feedback:simple_component/email@moneyadviceservice.org.uk.org.uk) }}
  CONTENT
)

thematic_reviews_landing_page_layout = english_site.layouts.find_or_create_by(
  identifier: 'thematic_reviews_landing_page',
  label: 'Thematic Reviews Landing Page',
  content:  <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Thematic Reviews }}
  CONTENT
)

english_site.pages.create!(
  label: 'How can we improve the financial capability of young adults?',
  slug: 'how-can-we-improve-the-financial-capability-of-young-adults',
  state: 'published',
  layout: thematic_review_layout,
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: 'Thematic Review content'
    ),
    Comfy::Cms::Block.new(
      identifier: 'overview',
      content: 'Some overview'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_description',
      content: 'Financial capability across the UK'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_cta_links',
      content: <<-CONTENT
        [Evidence Summaries Associated with this Thematic Review](/en/evidence_hub?tag=how-can-we-improve-the-financial-capability-of-young-adults)
        [All Evidence Summaries](/en/evidence_hub)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_download',
      content: <<-CONTENT
      [Young Adults Thematic review](/financial+capability+strategy.pdf)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_feedback',
      content: 'email@moneyadviceservice.org.uk'
    )
  ]
)

english_site.pages.create!(
  label: 'How can we encourage people to save, and to save more?',
  slug: 'how-can-we-encourage-people-to-save-and-to-save-more',
  state: 'published',
  layout: thematic_review_layout,
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
      This review aims to highlight the most recent, relevant and available research about how and why people save. It focuses on how we can promote ‘rainy day’ savings habits, rather than longer-term savings and retirement planning.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'overview',
      content: <<-CONTENT
      A critical aspect of both financial capability and financial resilience is having a savings buffer in order to pay unexpected bills or cover income shocks. Yet too many people in the UK have no such buffer and so resort to credit or borrowing from friends and family.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_description',
      content: 'Encouraging People to Save'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_cta_links',
      content: <<-CONTENT
        [Evidence Summaries Associated with this Thematic Review](/en/evidence_hub?tag=how-can-we-encourage-people-to-save-and-to-save-more)
        [All Evidence Summaries](/en/evidence_hub)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_download',
      content: <<-CONTENT
      [Young Adults Thematic review](/financial+capability+strategy.pdf)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_feedback',
      content: 'email@moneyadviceservice.org.uk'
    )
  ]
)

english_site.pages.create!(
  label: 'Thematic Reviews',
  slug: 'thematic_reviews',
  layout: thematic_reviews_landing_page_layout,
  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
Thematic Reviews are short overviews of key findings from multiple UK-based
research and ealuation reports on a particular topic. Each review will vary
depending on the available information, and will aim to include:

*   Headlines about context, landscape and needs
*   An introduction to evidence about what works well - and less well - to improve people's financial capability
*   Areas where further investigation is needed
*   Links to specific studies summarised elsewhere on the Hub

We hope our Thematic Reviews provide a useful overview to help you get a quick understanding on a particular topic,
or to act as a 'way in' to more detailed information contained in specific [Evidence Summaries](/evidence_hub_search).

Please contact us at [whatworks@fincap.org.uk](mailto:whatworks@fincap.org.uk) if you have any feedback,
including suggestions for research that you think should be covered
in future updates.
      CONTENT
    )
  ]
)

Comfy::Cms::Block.all.each do |block|
  block.update(
    processed_content: Mastalk::Document.new(block.content.strip).to_html
  )
end
