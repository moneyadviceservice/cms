RSpec.describe PageLink::PreviousLink do
  describe '#as_json' do
    let(:english_site) { create :site }
    let(:welsh_site) { create :site, :welsh }
    let(:category) { create :category }
    let!(:first_article) do
      create :page,
             position:   1,
             site:       english_site,
             categories: [category],
             label:      'previous_page',
             slug:       'previous-page',
             layout:     create(:layout, :article)
    end

    it 'provides the previous article' do
      second_article = create :page, position: 2, site: english_site, categories: [category], label: 'current_page'
      result = PageLink::PreviousLink.new(second_article).as_json

      expect(result[:title]).to eq('previous_page')
      expect(result[:path]).to eq('/en/articles/previous-page')
    end

    it 'returns empty hash when there are no categories' do
      second_article = create :page, position: 2, site: english_site, categories: [], label: 'current_page'
      result = PageLink::PreviousLink.new(second_article).as_json
      expect(result).to eq({})
    end

    it 'returns empty hash when this is the first article' do
      result = PageLink::PreviousLink.new(first_article).as_json
      expect(result).to eq({})
    end
  end
end
