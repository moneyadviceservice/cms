
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
      {{ cms:page:country_of_delivery }}
      {{ cms:page:links_to_research }}
      {{ cms:page:contact_details }}
      {{ cms:page:year_of_publication }}
      {{ cms:page:topics:collection_check_boxes foo bar baz }}
      {{ cms:page:client_groups }}
      {{ cms:page:country_of_delivery }}
    CONTENT
  )
end

layout = Comfy::Cms::Layout.find_by(identifier: 'insight')

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
      identifier: 'year_of_publication',
      content: '2015'
    ),
    Comfy::Cms::Block.new(
      identifier: 'links_to_research',
      content: <<-CONTENT
        [Financial well-being: the employee view - full report](https://www.cipd.co.uk/Images/financial-well-being-employee-view-report_tcm18-17439.pdf)'
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'contact_information',
      content: <<-CONTENT
        MASPD (in partnership with Company S.A)
        T +44 (0)20 1234 5678 F +44 (0)20 4567 1234
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
      content: <<-CONTENT
      [Moving forward together: peer support for people with problem debt - full report](https://masassets.blob.core.windows.net/cms/files/000/000/631/original/MAS_MovingForwardTogether_Report.pdf)
      CONTENT
    ),
    Comfy::Cms::Block.new(
      identifier: 'contact_information',
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
