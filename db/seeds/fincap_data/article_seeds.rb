english_site = Comfy::Cms::Site.find_or_create_by(
  label: 'en',
  identifier: 'money-advice-service-en',
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: 'en',
  locale: 'en',
  is_mirrored: true
)

article_layout = english_site.layouts.find_or_create_by(
  identifier: 'article',
  label: 'Article',
  content:  <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:page:cta_links:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
    {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
    {{ cms:page:feedback:simple_component/email@moneyadviceservice.org.uk.org.uk) }}
  CONTENT
)

english_site.pages.create!(
  label: 'UK Strategy',
  slug: 'uk-strategy',
  layout: article_layout,
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

        The belief, and the consistent message from stakeholders, is that levels
        of financial capability must be improved from their current low levels,
        and that if everybody works together it is possible to rise to the
        challenge. The changing financial environment makes this more important
        than ever before.

        ## **Why is it so important?**

        $~youtube_video

        JkhmfVGBkPM

        The Financial Capability Strategy for the UK Why is it needed?

        ~$

        ## **What is in the Strategy?**

        The Strategy sets out a clear description of the problem that needs to
        be solved and why it matters. It describes what success looks like over
        the lifetime of the Strategy and how the aims of the Strategy will be
        achieved.

        For the Strategy to be a success it is important that resources are
        allocated to interventions that are proven to work.

        The Strategy sets out the issues across a number of different themes
        and for each of the devolved nations (Northern Ireland, Scotland and
        Wales). We have produced a range of documents to allow stakeholders
        to understand the different audiences:

        1.  Executive Summary (4 pages)
        2.  The Strategy (50 pages)
        3.  The Full Strategy (150 pages)

        The Full Strategy has been broken down into chapters for those with a
        specific interest in any of the following areas:

        *   Introduction and context
        *   Evidence and evaluation
        *   Children and young people
        *   Young Adults
        *   Working Age
        *   Older People in Retirement
        *   Retirement Planning
        *   People in Financial Difficulties
        *   Ease and accessibility
        *   Northern Ireland
        *   Scotland
        *   Wales
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
      identifier: 'component_cta_links',
      content: <<-CONTENT
        [Evidence Hub](/general_info)
        [Evaluation Toolkit](/common-evaluation-toolkit)
        [The Steering Groups](/steering-groups)
        [2015 Financial Capability Survey](/financial-capability-survey)
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
    ),
    Comfy::Cms::Block.new(
      identifier: 'component_feedback',
      content: 'email@moneyadviceservice.org.uk'
    )
  ]
)

Comfy::Cms::Block.all.each do |block|
  block.update(
    processed_content: Mastalk::Document.new(block.content.strip).to_html
  )
end
