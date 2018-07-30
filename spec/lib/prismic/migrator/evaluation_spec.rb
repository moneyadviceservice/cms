RSpec.describe Prismic::Migrator::Evaluation do
  subject(:evaluation) { described_class.new(document)  }

  describe '#migrate' do
    subject(:migrated_page) { evaluation.migrate }
    let!(:site) { create(:site, label: 'en') }
    let!(:layout) { create(:layout, identifier: 'evaluation', site: site) }

    let(:document) do
      double(
        'Prismic::ConvertedDocument',
        formatted_title: 'Changing behaviour around online transactions',
        slug: 'changing-behaviour-around-online-transactions',
        description_of_the_programme: '<p>Some description</p>',
        the_study: '<p>The study</p>',
        what_are_the_outcomes: '<p>Outcomes<p>',
        key_findings: '<p>Some key findings</p>',
        NEW_what_are_the_costs: '<p>Some costs</p>',
        programme_delivery: '<p>Good Things Foundation and Toynbee Hall</p>',
        points_to_consider: '<p>Some points to consider</p>',
        links_to_research: '<p><a href="https://prismic-io.s3.amazonaws.com/fincap-two%2F1d626439-5c6a-4958-b5a4-3af50f05dba3_good+things+foundation+wwf+final+evaluation+report.pdf">Final Report</a> and <a href="https://prismic-io.s3.amazonaws.com/fincap-two%2F07f19389-445c-45c5-aa53-5aeffb02bbea_good+things+foundation+wwf+final+report+appendix.pdf">Appendix</a></p>',
        links_to_research_markdown: '',
        overview: '<p>An RCT testing the efficacy of live assisted digital transactions. Developed by Good Things Foundation and Toynbee Hall and delivered by 18 community organisations to struggling working-age people.</p>',
        overview_markdown: '',
        country_of_delivery: 'United Kingdom',
        contact_details: 'test@test.org',
        contact_details_markdown: '',
        year_of_publication: '2018',
        topics: [{ 'topic' => 'Financial Capability' }],
        country_search_filter_group: [{ 'country_search_filter' => '01England' }],
        client_groups: [{ 'client_group' => 'Working age (18 - 65)' }],
        NEW_delivery_channel: '<p>Workshops, group training / one-to-one advice</p>',
        NEW_delivery_channel_markdown: '',
        programme_theory: 'Yes',
        :'measured_outcomes_yes/no' => 'Yes',
        causality: 'Yes',
        process_evaluation: 'No',
        value_for_money: 'No',
        NEW_measured_outcomes: [
          {
            'outcome' => 'Financial capability (Mindset)'
          },
          {
            'outcome' => 'Financial capability (Ability)'
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
        %(<ol><li><a href="#description">Description of the programme</a></li><li><a href="#the-study">The study</a></li><li><a href="#effective">What are the outcomes?</a></li><li><a href="#key-findings">Key findings</a></li><li><a href="#costs">What are the costs?</a></li><li><a href="#points">Points to consider</a></li></ol><h2 id="description">Description of the programme</h2><p>Some description</p><h2 id="the-study">The study</h2><p>The study</p><h2 id="effective">What are the outcomes?</h2><p>Outcomes<p><h2 id="key-findings">Key findings</h2><p>Some key findings</p><h2 id="costs">What are the costs?</h2><p>Some costs</p><h2 id="points">Points to consider</h2><p>Some points to consider</p><h2>Full report</h2><p><a href="https://prismic-io.s3.amazonaws.com/fincap-two%2F1d626439-5c6a-4958-b5a4-3af50f05dba3_good+things+foundation+wwf+final+evaluation+report.pdf">Final Report</a> and <a href="https://prismic-io.s3.amazonaws.com/fincap-two%2F07f19389-445c-45c5-aa53-5aeffb02bbea_good+things+foundation+wwf+final+report+appendix.pdf">Appendix</a></p>)
      )
    end

    it 'persists other blocks' do
      blocks = migrated_page.blocks.where.not(identifier: 'content')
      expect(blocks[0].processed_content).to eq(
        '<p>An RCT testing the efficacy of live assisted digital transactions. Developed by Good Things Foundation and Toynbee Hall and delivered by 18 community organisations to struggling working-age people.</p>'
      )
      expect(blocks[5].processed_content).to eq(
        '<p>Workshops, group training / one-to-one advice</p>'
      )
      expect(blocks[6].processed_content).to eq(
        '<p>Good Things Foundation and Toynbee Hall</p>'
      )
      expect(blocks[7].processed_content).to eq(
        "<p>England</p>\n"
      )
      expect(blocks[8].content).to eq(
        'Financial Capability'
      )
      expect(blocks[9].processed_content).to eq(
        "<p>Working age (18 - 65)</p>\n"
      )
      expect(blocks[10].content).to eq(
        'Programme Theory'
      )
      expect(blocks[10].processed_content).to eq(
        "<p>Programme Theory</p>\n"
      )
      expect(blocks[11].content).to eq(
        'Measured Outcomes'
      )
      expect(blocks[11].processed_content).to eq(
        "<p>Measured Outcomes</p>\n"
      )
      expect(blocks[12].content).to eq(
        'Causality'
      )
      expect(blocks[13].content).to eq(
        'Financial capability (Mindset)'
      )
      expect(blocks[13].processed_content).to eq(
        "<p>Financial capability (Mindset)</p>\n"
      )
      expect(blocks[14].content).to eq(
        'Financial capability (Ability)'
      )
    end
  end
end
