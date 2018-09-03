RSpec.describe Prismic::Migrator::Review do
  subject(:review) { described_class.new(document) }

  describe '#migrate' do
    subject(:migrated_page) { review.migrate }
    let!(:site) { create(:site, label: 'en') }
    let!(:layout) { create(:layout, identifier: 'review', site: site) }

    let(:document) do
      double(
        'Prismic::ConvertedDocument',
        formatted_title: 'The role of financial education in decision-making for retirement',
        slug: 'the-role-of-financial-education-in-decision-making-for-retirement',
        links_to_research: %(<p><a href="http://www.keepeek.com/Digital-Asset-Management/oecd/finance-and-investment/oecd-pensions-outlook-2016/the-role-of-financial-education-in-supporting-decision-making-for-retirement_pens_outlook-2016-8-en#.WJyHElWLSUk#page1">The role of financial education in decision-making for retirement - full report</a></p>),
        links_to_research_markdown: '',
        overview: '<p>An OECD evidence review to understand the role of financial literacy relating to retirement, the challenges around retirement decisions and how FinEd needs to change according to main pension system. </p>',
        overview_markdown: '',
        country_of_delivery: 'United Kingdom, United States, OECD member nations',
        contact_details: '<p>OECD Publishing</p>',
        contact_details_markdown: '',
        year_of_publication: '2016',
        topics: [{ 'topic' => 'Pensions and Retirement Planning' }],
        country_search_filter_group: [
          { 'country_search_filter' => '0United Kingdom' },
          { 'country_search_filter' => '1United States' },
          { 'country_search_filter' => '2Other' }
        ],
        client_groups: [
          { 'client_group' => 'Young adults (17 - 24)' },
          { 'client_group' => 'Working age (18 - 65)' },
          { 'client_group' => 'Older people (65+)' }
        ],
        review_type: 'Systematic review',
        review_sections: [
          {
            'review_section_title' => 'Context',
            'review_section_content' => [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'Some context',
                  'spans' => [
                    { 'start' => 0, 'end' => 11, 'type' => 'strong' }
                  ]
                }
              }
            ]
          },
          {
            'review_section_title' => 'The study',
            'review_section_content' => [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'Some study',
                  'spans' => []
                }
              }
            ]
          },
          {
            'review_section_title' => 'Key findings',
            'review_section_content' => [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'Some findings',
                  'spans' => []
                }
              }
            ]
          },
          {
            'review_section_title' => 'Recommendations',
            'review_section_content' => [
              {
                'type' => 'paragraph',
                'content' => {
                  'text' => 'Some recommendations',
                  'spans' => []
                }
              }
            ]
          }
        ]
      )
    end

    it 'persisted to database' do
      expect(migrated_page).to be_persisted
    end

    it 'persists content' do
      block = migrated_page.blocks.find_by(identifier: 'content')
      expect(block).to_not be_nil
      expect(block.processed_content).to eq(
        '<ol><li><a href="#context">Context</a></li><li><a href="#the-study">The study</a></li><li><a href="#key-findings">Key findings</a></li><li><a href="#recommendations">Recommendations</a></li></ol><h2 id="context">Context</h2><p><strong>Some contex</strong>t</p><h2 id="the-study">The study</h2><p>Some study</p><h2 id="key-findings">Key findings</h2><p>Some findings</p><h2 id="recommendations">Recommendations</h2><p>Some recommendations</p><h2>Full report</h2><p><a href="http://www.keepeek.com/Digital-Asset-Management/oecd/finance-and-investment/oecd-pensions-outlook-2016/the-role-of-financial-education-in-supporting-decision-making-for-retirement_pens_outlook-2016-8-en#.WJyHElWLSUk#page1">The role of financial education in decision-making for retirement - full report</a></p>'
      )
    end

    it 'persists other blocks' do
      blocks = migrated_page.blocks.where.not(identifier: 'content')
      expect(blocks[0].identifier).to eq('overview')
      expect(blocks[0].processed_content).to eq(
        '<p>An OECD evidence review to understand the role of financial literacy relating to retirement, the challenges around retirement decisions and how FinEd needs to change according to main pension system. </p>'
      )
      expect(blocks[1].identifier).to eq('countries')
      expect(blocks[1].processed_content).to eq('United Kingdom, United States, OECD member nations')
      expect(blocks[2].identifier).to eq('links_to_research')
      expect(blocks[2].processed_content).to eq('<p><a href="http://www.keepeek.com/Digital-Asset-Management/oecd/finance-and-investment/oecd-pensions-outlook-2016/the-role-of-financial-education-in-supporting-decision-making-for-retirement_pens_outlook-2016-8-en#.WJyHElWLSUk#page1">The role of financial education in decision-making for retirement - full report</a></p>')
      expect(blocks[3].identifier).to eq('contact_information')
      expect(blocks[3].processed_content).to eq('<p>OECD Publishing</p>')
      expect(blocks[4].identifier).to eq('year_of_publication')
      expect(blocks[4].processed_content).to eq('2016')
      expect(blocks[5].identifier).to eq('topics')
      expect(blocks[5].processed_content).to eq("<p>Pensions and Retirement Planning</p>\n")
      expect(blocks[6].identifier).to eq('countries_of_delivery')
      expect(blocks[6].processed_content).to eq("<p>United Kingdom</p>\n")
      expect(blocks[7].identifier).to eq('countries_of_delivery')
      expect(blocks[7].processed_content).to eq("<p>United States</p>\n")
      expect(blocks[8].identifier).to eq('countries_of_delivery')
      expect(blocks[8].processed_content).to eq("<p>Other</p>\n")
      expect(blocks[9].identifier).to eq('client_groups')
      expect(blocks[9].processed_content).to eq("<p>Young adults (17 - 24)</p>\n")
      expect(blocks[10].identifier).to eq('client_groups')
      expect(blocks[10].processed_content).to eq("<p>Working age (18 - 65)</p>\n")
      expect(blocks[11].identifier).to eq('client_groups')
      expect(blocks[11].processed_content).to eq("<p>Older people (65+)</p>\n")
      expect(blocks[12].identifier).to eq('data_types')
      expect(blocks[12].processed_content).to eq("<p>Systematic review</p>\n")
    end
  end
end
