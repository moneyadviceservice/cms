english_site = Comfy::Cms::Site.find_or_create_by(
  label: 'en',
  identifier: 'money-advice-service-en',
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: 'en',
  locale: 'en',
  is_mirrored: true
)

layouts = YAML::load_file("#{Rails.root}/config/fincap_layouts.yml")
uk_strategy_layout = english_site.layouts.find_or_create_by(layouts[:uk_strategy])

english_site.pages.create!(
  label: 'UK Strategy',
  slug: 'uk-strategy',
  layout: uk_strategy_layout,
  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
        This Strategy aims to improve financial capability across the UK.
        That means improving people’s ability to manage money well,
        both day to day and through significant life events, and their ability
        to handle periods of financial difficulty. It will focus on developing
        people’s financial skills and knowledge, and improving their attitudes
        and motivation. This, combined with an inclusive financial system,
        can help people achieve the best possible financial wellbeing.
      CONTENT
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
      identifier: 'teaser_section_title',
      content: 'Financial capability across the UK in action'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_title',
      content: 'Executive Summary'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_text',
      content: 'This is the executive summary content'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser1_link',
      content: '[teaser1 link text](/exectutive+summary.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_title',
      content: 'The Strategy'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_text',
      content: 'This is the strategy content'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser2_link',
      content: '[Read more](/the+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_title',
      content: 'The Full Strategy'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_image',
      content: '/assets/styleguide/hero-sample.jpg'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_text',
      content: 'This is the full strategy content'
    ),
    Comfy::Cms::Block.new(
      identifier: 'teaser3_link',
      content: '[Click here](/the+full+strategy.pdf)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'regional_strategy_title',
      content: 'Regional strategy article'
    ),
    Comfy::Cms::Block.new(
      identifier: 'regional_strategy_text',
      content: 'To find out more about the regional strategy follow the link below'
    ),
    Comfy::Cms::Block.new(
      identifier: 'regional_strategy_link',
      content: <<-CONTENT
      [Regional strategy](/regional-strategy-link)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_download',
      content: <<-CONTENT
      [UK Strategy](/financial+capability+strategy.pdf)
      [UK Detailed Strategy](/detailed-strategy.pdf)
      [Key statistics on Financial Capability](/key-statistics.pdf)
      [Financial Capability Progress Report 2017](/fincap+progress+report+2017.pdf)
      CONTENT
    )
  ]
)

Comfy::Cms::Block.all.each do |block|
  block.update(
    processed_content: Mastalk::Document.new(block.content.strip).to_html
  )
end
