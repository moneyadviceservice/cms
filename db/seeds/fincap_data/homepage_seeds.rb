english_site = Comfy::Cms::Site.find_or_create_by(
  label: 'en',
  identifier: 'money-advice-service-en',
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: 'en',
  locale: 'en',
  is_mirrored: true
)

layouts = YAML::load_file("#{Rails.root}/config/fincap_layouts.yml")
homepage_layout = english_site.layouts.find_or_create_by(layouts[:homepage])

homepage_page = english_site.pages.create!(
  label: 'Financial Capability',
  slug: 'root',
  layout: homepage_layout,

  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
Welcome to the Financial Capability website, which provides the latest updates on the development 
of the Financial Capability Strategy for the UK, as well as resources and practical tools to help 
share learning about what works.
Click [here](https://www.fincap.org.uk/fincapweek) for information about Talk Money Week, the annual event which showcases and celebrates 
how organisations are improving financial wellbeing and supporting the work of the Financial 
Capability Strategy.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_hero_description',
      content: 'Welcome to the Financial Capability website'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser_section_title',
      content: 'Financial capability in action'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_title',
      content: 'First teaser title'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_text',
      content: 'A bunch of ipsem lorem'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_link',
      content: '[Read more](/financial+capability+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_title',
      content: 'Second teaser title'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_text',
      content: 'Kitchen sink ipsem lorem text'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_link',
      content: '[Call to action](/financial+capability+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_title',
      content: 'Third teaser title'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_text',
      content: 'I have run out of ipsem lorem ideas.'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_link',
      content: '[Get involved](/financial+capability+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'horizontal_teaser_title',
      content: 'Horizontal teaser title'
    ),
    Comfy::Cms::Block.new(
      identifier: 'horizontal_teaser_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'horizontal_teaser_text',
      content: 'Horizontal teaser content.'
    ),
    Comfy::Cms::Block.new(
      identifier: 'horizontal_teaser_link',
      content: '[Click here](/financial+capability+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_download',
      content: <<-CONTENT
      [Young Adults download](/financial+capability+strategy.pdf)
      CONTENT
    )
  ]
)

Comfy::Cms::Block.all.each do |block|
  block.update(
    processed_content: Mastalk::Document.new(block.content.strip).to_html
  )
end
