english_site = Comfy::Cms::Site.find_or_create_by(
  label: 'en',
  identifier: 'money-advice-service-en',
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: 'en',
  locale: 'en',
  is_mirrored: true
)

lifestage_layout = english_site.layouts.find_or_create_by(
  identifier: 'lifestage',
  label: ' Lifestage',
  content:  <<-CONTENT
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
    {{ cms:page:strategy_overview }}
    {{ cms:page:strategy_link }}
    {{ cms:page:steering_group_title }}
    {{ cms:page:steering_group_links }}
    {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
  CONTENT
)

lifestage_pages = []

[
  'Young Adults',
  'Children and Young People',
  'Working Age Adults',
  'Older People in Retirement',
  'People planning to retire',
  'People in Financial difficulties',
  'People trying to save',
  'Dummy category 1',
  'Dummy category 2',
  'Dummy category 3',
  'Dummy category 4',
  'Dummy category 5',
].each do |stage|
  english_site.pages.create!(
    label: stage,
    meta_description: 'This is an example paragraph containing a description about a specific lifestage.',
    slug: stage.gsub(' ', '_').downcase,
    layout: lifestage_layout,

    state: 'published',
    blocks: [
      Comfy::Cms::Block.new(
        identifier: 'content',
        content: <<-CONTENT
          This is an example paragraph containing information about a specific lifestage.
        CONTENT
      ),
      Comfy::Cms::Block.new(
        identifier: 'component_hero_image',
        content: '/assets/styleguide/hero-sample.jpg'
      ),
      Comfy::Cms::Block.new(
        identifier: 'component_hero_description',
        content: "Research suggests that #{stage} typically display lower levels of financial capability than other age groups."
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser_section_title',
        content: 'Financial capability in action'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser1_title',
        content: 'Some title to tease you'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser1_image',
        content: '/assets/styleguide/hero-sample.jpg'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser1_text',
        content: 'Loads of content to make you read more'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser1_link',
        content: '[teaser1 link text](/financial+capability+strategy.pdf)'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser2_title',
        content: 'Another title to entice you'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser2_image',
        content: '/assets/styleguide/hero-sample.jpg'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser2_text',
        content: 'A bunch of well written content to make you click'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser2_link',
        content: '[Read more](/financial+capability+strategy.pdf)'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser3_title',
        content: 'Teasing title'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser3_image',
        content: '/assets/styleguide/hero-sample.jpg'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser3_text',
        content: 'You want to read this, you need to read this'
      ),
      Comfy::Cms::Block.new(
        identifier: 'teaser3_link',
        content: '[Click here](/financial+capability+strategy.pdf)'
      ),
      Comfy::Cms::Block.new(
        identifier: 'strategy_title',
        content: 'Strategy Title'
      ),
      Comfy::Cms::Block.new(
        identifier: 'strategy_overview',
        content: 'Adult financial capability is a direct resul'
      ),
      Comfy::Cms::Block.new(
        identifier: 'strategy_link',
        content: '[Link to strategy](/financial+capability+strategy.pdf)'
      ),
      Comfy::Cms::Block.new(
        identifier: 'steering_group_title',
        content: 'Steering group'
      ),
      Comfy::Cms::Block.new(
        identifier: 'steering_group_links',
        content: <<-CONTENT
          [Steering group members](/financial+capability+strategy.pdf)
          [Steering group updates](/financial+capability+strategy.pdf)
          [Action plans](/financial+capability+strategy.pdf)
        CONTENT
      ),
      Comfy::Cms::Block.new(
        identifier: 'component_download',
        content: <<-CONTENT
        [Lifestage category download](/financial+capability+strategy.pdf)
        CONTENT
      ),
    ]
  )
end

mobile_payments_tag = Tag.find_or_create_by(value: 'mobile-payments')
lifestage_pages.each { |page| page.keywords << mobile_payments_tag }

Comfy::Cms::Block.all.each do |block|
  block.update(
    processed_content: Mastalk::Document.new(block.content.strip).to_html
  )
end
