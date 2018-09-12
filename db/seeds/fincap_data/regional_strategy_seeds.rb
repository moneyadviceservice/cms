english_site = Comfy::Cms::Site.find_or_create_by(
  label: 'en',
  identifier: 'money-advice-service-en',
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: 'en',
  locale: 'en',
  is_mirrored: true
)

regional_strategy_layout = english_site.layouts.find_or_create_by(
  identifier: 'regional_strategy',
  label: 'Regional Strategy',
  content: <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:page:teaser_section_title }}
    {{ cms:page:teaser1_title }}
    {{ cms:page:teaser1_image }}
    {{ cms:page:teaser1_text }}
    {{ cms:page:teaser1_link }}
    {{ cms:page:teaser2_title }}
    {{ cms:page:teaser2_image }}
    {{ cms:page:teaser2_text }}
    {{ cms:page:teaser2_link }}
    {{ cms:page:teaser3_title }}
    {{ cms:page:teaser3_image }}
    {{ cms:page:teaser3_text }}
    {{ cms:page:teaser3_link }}
    {{ cms:page:strategy_title }}
    {{ cms:page:strategy_text }}
    {{ cms:page:strategy_link }}
    {{ cms:page:forum_title}}
    {{ cms:page:forum_links}}
    {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
  CONTENT
)

mobile_payments_tag = Tag.find_or_create_by(value: 'mobile-payments')

regional_strategy_page = english_site.pages.create!(
  label: 'Wales',
  slug: 'wales',
  layout: regional_strategy_layout,
  keywords: [mobile_payments_tag],

  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
The usually resident population of Wales was 3.1 million people living in 1.3 million households
in 2011, with nearly one in five of residents aged 65 or over. Wales had a higher percentage of
residents with a long-term health problem or disability. One in four of those aged 16 and over
reported having no recognised qualification. There are 700,000 people in poverty in Wales,
equivalent to 23 per cent of the population.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_description',
      content: 'The Welsh Government has long recognised that financial exclusion and over-indebtedness are issues that need concerted action'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser_section_title',
      content: 'Financial capability in action'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_title',
      content: 'Child Poverty Strategy'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_text',
      content: 'New objectives for improving the outcomes of children and young people living in low income households.'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_link',
      content: '[teaser1 link text](/financial+capability+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_title',
      content: 'Strategy for Older People'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_text',
      content: 'Delivery Action Plan for Living Longer, Living Better focuses on the three priorities for the Strategy for Older People.'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_link',
      content: '[Read more](/financial+capability+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_title',
      content: 'Warm Homes programme'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_text',
      content: 'The government has made considerable investment to address home energy efficiency in low income communities and households.'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_link',
      content: '[Click here](/financial+capability+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_download',
      content: <<-CONTENT
      [Young Adults download](/financial+capability+strategy.pdf)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'strategy_title',
      content: 'Wales Financial Capability Strategy'
    ),
    Comfy::Cms::Block.new(
      identifier: 'strategy_text',
      content: 'There is general agreement that there should be one Strategy for Wales.'
    ),
    Comfy::Cms::Block.new(
      identifier: 'strategy_link',
      content: '[Link to strategy](/financial+capability+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'forum_title',
      content: 'Forum'
    ),
    Comfy::Cms::Block.new(
      identifier: 'forum_links',
      content: <<-CONTENT
        [Welsh Forum](/financial+capability+strategy.pdf)
        [Money Advice Service Wales Forum](/financial+capability+strategy.pdf)
        [Development Group](/financial+capability+strategy.pdf)
      CONTENT
    )
  ]
)

Comfy::Cms::Block.all.each do |block|
  block.update(
    processed_content: Mastalk::Document.new(block.content.strip).to_html
  )
end
