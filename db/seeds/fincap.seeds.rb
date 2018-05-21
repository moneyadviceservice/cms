Comfy::Cms::User.create_with(password: 'password', role: 'admin').find_or_create_by!(email: 'user@test.com')

english_site = Comfy::Cms::Site.find_or_create_by(
  label: 'en',
  identifier: 'money-advice-service-en',
  hostname: ENV['HOSTNAME'] || 'localhost:3000',
  path: 'en',
  locale: 'en',
  is_mirrored: true
)

%w(insight).each do |layout|
  english_site.layouts.find_or_create_by(
    identifier: layout,
    label: layout.titleize,
    content:  <<-CONTENT
      {{ cms:page:content:rich_text }}
      {{ cms:page:overview }}
      {{ cms:page:countries }}
      {{ cms:page:links_to_research }}
      {{ cms:page:contact_information }}
      {{ cms:page:year_of_publication }}
      {{ cms:page:topics:collection_check_boxes/Saving, Pensions and Retirement Planning, Credit Use and Debt, Budgeting and Keeping Track, Insurance and Protection, Financial Education, Financial Capability }}
      {{ cms:page:countries_of_delivery:collection_check_boxes/United Kingdom, England, Northern Ireland, Scotland, Wales, USA, Other }}
      {{ cms:page:client_groups:collection_check_boxes/Children (3 - 11), Young People (12 - 16), Parents/Families, Young Adults (17 - 24), Working Age (18 - 65), Older People (65+), Over-indebted people, Social housing tenants, Teachers/practitioners, Other }}
      {{ cms:page:data_types:collection_check_boxes/Quantitative, Qualitative }}
    CONTENT
  )
end

evaluation_layout = english_site.layouts.find_or_create_by(
  identifier: 'evaluation',
  label: 'Evaluation',
  content: <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:overview }}
    {{ cms:page:countries }}
    {{ cms:page:links_to_research }}
    {{ cms:page:contact_information }}
    {{ cms:page:year_of_publication }}
    {{ cms:page:activities_and_setting }}
    {{ cms:page:programme_delivery }}
    {{ cms:page:countries_of_delivery:collection_check_boxes/United Kingdom, England, Northern Ireland, Scotland, Wales, USA, Other }}
    {{ cms:page:topics:collection_check_boxes/Saving, Pensions and Retirement Planning, Credit Use and Debt, Budgeting and Keeping Track, Insurance and Protection, Financial Education, Financial Capability }}
      {{ cms:page:client_groups:collection_check_boxes/Children (3 - 11), Young People (12 - 16), Parents/Families, Young Adults (17 - 24), Working Age (18 - 65), Older People (65+), Over-indebted people, Social housing tenants, Teachers/practitioners, Other }}
    {{ cms:page:data_types:collection_check_boxes/Programme Theory, Measured Outcomes, Causality, Process Evaluation, Value for money }}
    {{ cms:page:measured_outcomes:collection_check_boxes/Financial wellbeing, Financial behaviour, Financial capability (connection), Financial capability (mindset), Financial capability (Ability) }}
  CONTENT
)

review_layout = english_site.layouts.find_or_create_by(
  identifier: 'review',
  label: 'Review',
  content:  <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:overview }}
    {{ cms:page:countries }}
    {{ cms:page:links_to_research }}
    {{ cms:page:contact_information }}
    {{ cms:page:year_of_publication }}
    {{ cms:page:topics:collection_check_boxes/Saving, Pensions and Retirement Planning, Credit Use and Debt, Budgeting and Keeping Track, Insurance and Protection, Financial Education, Financial Capability }}
    {{ cms:page:countries_of_delivery:collection_check_boxes/United Kingdom, England, Northern Ireland, Scotland, Wales, USA, Other }}
      {{ cms:page:client_groups:collection_check_boxes/Children (3 - 11), Young People (12 - 16), Parents/Families, Young Adults (17 - 24), Working Age (18 - 65), Older People (65+), Over-indebted people, Social housing tenants, Teachers/practitioners, Other }}
    {{ cms:page:data_types:collection_check_boxes/Literature review, Systematic review }}
  CONTENT
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

layout = Comfy::Cms::Layout.find_by(identifier: 'insight')

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

english_site.pages.create!(
  label: 'Financial well-being: the employee view',
  slug:  'financial-well-being-the-employee-view',
  layout: layout,
  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
Context

The survey explores employees’ views on attitudes to finances.
Stress caused by pay levels, lack of financial awareness or absence of
employee benefits can affect work performance.
In addition, the perception that their contributions are not being
acknowledged can have an impact on employee self-esteem, health and
productivity.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'overview',
      content: <<-CONTENT
        The survey explores employees’ views on attitudes to finances.
        Stress caused by pay levels, lack of financial awareness or absence of
        employee benefits can affect work performance.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'countries',
      content: 'United Kingdom'
    ),
    Comfy::Cms::Block.new(
      identifier: 'links_to_research',
      processed_content: %{
        <a href="https://www.cipd.co.uk/Images/financial-well-being-employee-view-report_tcm18-17439.pdf">Financial well-being: the employee view - full report</a>
      },
      content: <<-CONTENT
        [Financial well-being: the employee view - full report](https://www.cipd.co.uk/Images/financial-well-being-employee-view-report_tcm18-17439.pdf)'
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'contact_information',
      processed_content: %{
        <p>
          MASPD (in partnership with Company S.A)
          T +44 (0)20 1234 5678 F +44 (0)20 4567 1234
        </p>
      },
      content: <<-CONTENT
        MASPD (in partnership with Company S.A)
        T +44 (0)20 1234 5678 F +44 (0)20 4567 1234
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'year_of_publication',
      content: '2015'
    ),
    Comfy::Cms::Block.new(
      identifier: 'topics',
      content: 'Saving'
    ),
    Comfy::Cms::Block.new(
      identifier: 'topics',
      content: 'Financial Capability'
    ),
    Comfy::Cms::Block.new(
      identifier: 'client_groups',
      content: 'Over-indebted people'
    ),
    Comfy::Cms::Block.new(
      identifier: 'data_types',
      content: 'Qualitative'
    )
  ]
)

english_site.pages.create!(
  label: 'Moving forward together: peer support for people with problem debt',
  slug:  'moving-forward-together-peer-support-for-people-with-problem-debt',
  layout: layout,
  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
Context

Research has found that there remains a real stigma around seeking advice
for debt, with many people feeling that doing so means that they have
 ‘failed’, but that talking about debt problems is also cathartic.
This suggests there is potential value in peer-support for over-indebted
people, based on models in other fields such as weight loss.

Peer support is usually intended to encourage behaviour change and is
provided by peer mentors (those who have led or given support within
peer support programmes).

Such innovation, however, needs an evidence base, so research was needed
to explore the peer-support landscape and establish how it helps people
to resolve their difficulties and change their behaviour.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'year_of_publication',
      content: '2017'
    ),
    Comfy::Cms::Block.new(
      identifier: 'links_to_research',
      processed_content: %{
       <a href="https://masassets.blob.core.windows.net/cms/files/000/000/631/original/MAS_MovingForwardTogether_Report.pdf">Moving forward together: peer support for people with problem debt - full report</a>
      },
      content: <<-CONTENT
      [Moving forward together: peer support for people with problem debt - full report](https://masassets.blob.core.windows.net/cms/files/000/000/631/original/MAS_MovingForwardTogether_Report.pdf)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'contact_information',
      processed_content: '<p>peersupport@moneyadviceservice.org.uk</p>',
      content: <<-CONTENT
        peersupport@moneyadviceservice.org.uk
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'overview',
      content: <<-CONTENT
        Research has found that there remains a real stigma around seeking
        advice for debt, with many people feeling that doing so means that
        they have ‘failed’, but that talking about debt problems is also
        cathartic.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'countries',
      content: 'England'
    ),
    Comfy::Cms::Block.new(
      identifier: 'topics',
      content: 'Credit Use and Debt'
    ),
    Comfy::Cms::Block.new(
      identifier: 'client_groups',
      content: 'Over-indebted people'
    ),
    Comfy::Cms::Block.new(
      identifier: 'client_groups',
      content: 'Working age (18 - 65)'
    )
  ]
)

english_site.pages.create!(
  label: 'Looking after the pennies',
  slug: 'looking-after-the-pennies',
  layout: evaluation_layout,
  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
The trackers are all available as free smartphone apps (although at the
time of writing, Toshl is discontinued). Overall user numbers of the apps
are not given. However, 797 customers entered into the project (by
completing a first questionnaire and downloading an app) from across
the UK between July and November 2016.

The intervention was undertaken in participants’ own time as part their
daily lives.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'overview',
      content: <<-CONTENT
        An evaluation, commissioned by Royal London, of the impacts of using
        simple budgeting tools on customers’ money management attitudes and
        behaviours.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'client_groups',
      content: 'Working age (18 - 65)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'client_groups',
      content: 'Older people (65+)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'topics',
      content: 'Budgeting and keeping track'
    ),
    Comfy::Cms::Block.new(
      identifier: 'activities_and_setting',
      content: 'Comparison of budgeting apps vs. pen and paper methods'
    ),
    Comfy::Cms::Block.new(
      identifier: 'programme_delivery',
      content: 'Money Advice'
    ),
    Comfy::Cms::Block.new(
      identifier: 'countries',
      content: 'United Kingdom'
    ),
    Comfy::Cms::Block.new(
      identifier: 'year_of_publication',
      content: '2017'
    ),
    Comfy::Cms::Block.new(
      identifier: 'data_types',
      content: 'Measured Outcomes'
    ),
    Comfy::Cms::Block.new(
      identifier: 'links_to_research',
      processed_content: %{
        <a href='https://www.royallondon.com/Documents/PDFs/2017/Royal%20London%20-%20Looking%20after%20the%20pennies.pdf'>Looking after the pennies - full report</a>
        <a href='https://fincap-two.cdn.prismic.io/fincap-two%2F0efeee0b-252a-4b13-b7f5-d05e66bdc6aa_final+report+-+royal+london+fincap.pptx'>Follow-up report</a>
      },
      content: <<-CONTENT
      [Looking after the pennies - full report](https://www.royallondon.com/Documents/PDFs/2017/Royal%20London%20-%20Looking%20after%20the%20pennies.pdf)

      [Follow-up report](https://fincap-two.cdn.prismic.io/fincap-two%2F0efeee0b-252a-4b13-b7f5-d05e66bdc6aa_final+report+-+royal+london+fincap.pptx)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'contact_information',
      processed_content: %{
      <p>MASPD (in partnership with Company S.A)
         T +44 (0)20 1234 5678 F +44 (0)20 4567 1234</p>
      },
      content: <<-CONTENT
        MASPD (in partnership with Company S.A)
        T +44 (0)20 1234 5678 F +44 (0)20 4567 1234
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'measured_outcomes',
      content: 'Financial capability (Mindset)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'measured_outcomes',
      content: 'Financial capability (Ability)'
    )
  ]
)

english_site.pages.create!(
  label: 'Raising household saving',
  slug: 'raising-household-saving',
  layout: review_layout,
  state: 'published',
  blocks: [
    Comfy::Cms::Block.new(
      identifier: 'content',
      content: <<-CONTENT
Context

 There is continuing concern in the UK and internationally that many individuals are making insufficient savings, especially for retirement. This has long been a key issue in UK policy discussions – demonstrated by the continual modifications to the retirement pension system throughout the 21st century (and before).
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'year_of_publication',
      content: '2012'
    ),
    Comfy::Cms::Block.new(
      identifier: 'links_to_research',
      content: <<-CONTENT
[Raising household saving - full report](https://www.britac.ac.uk/sites/default/files/BRI1089_household_saving_report_02.12_WEB_FINAL.pdf)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'contact_information',
      content: <<-CONTENT
John Smith, John Smith

Institute for Studies

https://www.company-name.org.uk/
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'overview',
      content: <<-CONTENT
Based on an analysis of international evidence, this report examines in detail what is known – and what is not known – about the effectiveness of different sorts of interventions designed to raise household savings.
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'countries',
      content: 'International review'
    ),
    Comfy::Cms::Block.new(
      identifier: 'topics',
      content: 'Saving'
    ),
    Comfy::Cms::Block.new(
      identifier: 'topics',
      content: 'Pensions and Retirement Planning'
    ),
    Comfy::Cms::Block.new(
      identifier: 'topics',
      content: 'Financial Education'
    ),
    Comfy::Cms::Block.new(
      identifier: 'client_groups',
      content: 'Children (3 - 11)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'client_groups',
      content: 'Young people (12 - 16)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'client_groups',
      content: 'Parents / families'
    ),
    Comfy::Cms::Block.new(
      identifier: 'client_groups',
      content: 'Young adults (17 - 24)'
    ),
    Comfy::Cms::Block.new(
      identifier: 'data_types',
      content: 'Systematic review'
    )
  ]
)

Comfy::Cms::Block.all.each do |block|
  block.update(
    processed_content: Mastalk::Document.new(block.content.strip).to_html
  )
end
