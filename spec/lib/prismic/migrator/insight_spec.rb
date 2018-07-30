RSpec.describe Prismic::Migrator::Insight do
  subject(:insight) { described_class.new(document)  }

  describe '#migrate' do
    subject(:migrated_page) { insight.migrate }
    let!(:site) { create(:site, label: 'en') }
    let!(:layout) { create(:layout, identifier: 'insight', site: site) }

    context 'when document has all fields for content' do
      let(:document) do
        double(
          'Prismic::ConvertedDocument',
          formatted_title: 'The economic impact of debt advice',
          slug: 'the-economic-impact-of-debt-advice',
          layout_identifier: 'insight',
          context: '<p>Some context</p>',
          the_study: '<p>Some study</p>',
          key_findings: '<p>Some key findings</p>',
          points_to_consider: '<p>Some points to consider</p>',
          links_to_research: '<p><a href="https://www.moneyadviceservice.org.uk/en/corporate/economicimpactdebtadvice">The economic impact of debt advice - full report </a></p>',
          links_to_research_markdown: "[The economic impact of debt advice - full report](https://www.moneyadviceservice.org.uk/en/corporate/economicimpactdebtadvice)\n\n",
          overview: "<p>This study explores the economic impact of debt advice, comparing the experiences of those who have or haven't sought debt advice. </p>",
          overview_markdown: "This study explores the economic impact of debt advice, comparing the experiences of those who have or haven't sought debt advice.\n\n",
          country_of_delivery: 'United Kingdom',
          contact_details_markdown: 'Europe Economics\n\nChancery House\n\n53-64 Chancery Lane\n\nLondon, WC2A IQA.\n\n',
          contact_details: '<p>Europe Economics</p><p>Chancery House</p><p>53-64 Chancery Lane</p><p>London, WC2A IQA.</p>',
          year_of_publication: '2018',
          topics: [{ 'topic' => 'Financial Capability' }],
          country_search_filter_group: [{ 'country_search_filter' => '01England' }],
          client_groups: [{ 'client_group' => 'Working age (18 - 65)' }, { 'client_group' => 'Over-indebted people' }],
          qualitative: 'Yes',
          quantitative: nil
        )
      end

      it 'persisted to database' do
        expect(migrated_page).to be_persisted
      end

      it 'persists content' do
        block = migrated_page.blocks.find_by(identifier: 'content')
        expect(block).to_not be_nil
        expect(block.processed_content).to eq(
          %(<ol><li><a href="#context">Context</a></li><li><a href="#the-study">The study</a></li><li><a href="#key-findings">Key findings</a></li><li><a href="#points">Points to consider</a></li></ol><h2 id="context">Context</h2><p>Some context</p><h2 id="the-study">The study</h2><p>Some study</p><h2 id="key-findings">Key findings</h2><p>Some key findings</p><h2 id="points">Points to consider</h2><p>Some points to consider</p><h2>Full report</h2><p><a href="https://www.moneyadviceservice.org.uk/en/corporate/economicimpactdebtadvice">The economic impact of debt advice - full report </a></p>)
        )
      end

      it 'persists other blocks' do
        blocks = migrated_page.blocks.where.not(identifier: 'content')
        expect(blocks[0].processed_content).to eq(
          "<p>This study explores the economic impact of debt advice, comparing the experiences of those who have or haven't sought debt advice. </p>"
        )
        expect(blocks[5].processed_content).to eq(
          "<p>Financial Capability</p>\n"
        )
        expect(blocks[6].processed_content).to eq(
          "<p>England</p>\n"
        )
        expect(blocks[7].content).to eq(
          'Working age (18 - 65)'
        )
        expect(blocks[8].processed_content).to eq(
          "<p>Over-indebted people</p>\n"
        )

      end
    end

    context 'when document does not have all fields for content' do
      let(:document) do
        double(
          'Prismic::ConvertedDocument',
          formatted_title: 'The economic impact of debt advice',
          slug: 'the-economic-impact-of-debt-advice',
          layout_identifier: 'insight',
          context: '<p>Some context</p>',
          the_study: nil,
          key_findings: '<p>Some key findings</p>',
          points_to_consider: '<p>Some points to consider</p>',
          links_to_research: '<p><a href="https://www.moneyadviceservice.org.uk/en/corporate/economicimpactdebtadvice">The economic impact of debt advice - full report </a></p>',
          links_to_research_markdown: "[The economic impact of debt advice - full report](https://www.moneyadviceservice.org.uk/en/corporate/economicimpactdebtadvice)\n\n",
          overview: "<p>This study explores the economic impact of debt advice, comparing the experiences of those who have or haven't sought debt advice. </p>",
          overview_markdown: "This study explores the economic impact of debt advice, comparing the experiences of those who have or haven't sought debt advice.\n\n",
          country_of_delivery: 'United Kingdom',
          contact_details_markdown: 'Europe Economics\n\nChancery House\n\n53-64 Chancery Lane\n\nLondon, WC2A IQA.\n\n',
          contact_details: '<p>Europe Economics</p><p>Chancery House</p><p>53-64 Chancery Lane</p><p>London, WC2A IQA.</p>',
          year_of_publication: '2018',
          topics: [{ 'topic' => 'Financial Capability' }],
          country_search_filter_group: [{ 'country_search_filter' => '01England' }],
          client_groups: [{ 'client_group' => 'Working age (18 - 65)' }, { 'client_group' => 'Over-indebted people' }],
          qualitative: 'Yes',
          quantitative: nil
        )
      end

      it 'persists content' do
        block = migrated_page.blocks.find_by(identifier: 'content')
        expect(block).to_not be_nil
        expect(block.processed_content).to eq(
          %(<ol><li><a href="#context">Context</a></li><li><a href="#key-findings">Key findings</a></li><li><a href="#points">Points to consider</a></li></ol><h2 id="context">Context</h2><p>Some context</p><h2 id="key-findings">Key findings</h2><p>Some key findings</p><h2 id="points">Points to consider</h2><p>Some points to consider</p><h2>Full report</h2><p><a href="https://www.moneyadviceservice.org.uk/en/corporate/economicimpactdebtadvice">The economic impact of debt advice - full report </a></p>)
        )
      end
    end
  end
end
