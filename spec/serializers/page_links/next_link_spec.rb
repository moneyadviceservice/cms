RSpec.describe PageLink::NextLink do

  describe '#as_json' do
    let(:english_site) { create :site }
    let(:welsh_site) { create :site, :welsh }
    let(:category) { create :category }
    let!(:first_article) do
      create :page,
             position:   1,
             site:       english_site,
             categories: [category],
             label:      'current_page',
             slug:       'current-page',
             layout:     create(:layout, :article)
    end

    it 'provides the next article' do
      create :page,
             position: 2,
             site: english_site,
             categories: [category],
             label: 'next_page',
             slug: 'next-page',
             layout: create(:layout, :article)
      result = PageLink::NextLink.new(first_article).as_json

      expect(result[:title]).to eq('next_page')
      expect(result[:path]).to eq('/en/articles/next-page')
    end

    it 'returns empty hash when there are no categories' do
      second_article = create :page, position: 2, site: english_site, categories: [], label: 'current_page'
      result = PageLink::NextLink.new(second_article).as_json
      expect(result).to eq({})
    end

    it 'returns empty hash when this is the last article' do
      result = PageLink::NextLink.new(first_article).as_json
      expect(result).to eq({})
    end

    context 'when next article is an action plan' do
      let!(:next_page) do
        create :page,
               position: 2,
               site: english_site,
               categories: [category],
               label: 'next_page',
               slug: 'next-page',
               layout: create(:layout, :article, identifier: 'action_plan')
      end

      it 'uses the layout in the url' do
        result = PageLink::NextLink.new(first_article).as_json

        expect(result[:title]).to eq('next_page')
        expect(result[:path]).to eq('/en/action_plans/next-page')
      end
    end

    context 'when next article is corporate' do
      let!(:next_page) do
        create :page,
               position: 2,
               site: english_site,
               categories: [category],
               label: 'next_page',
               slug: 'next-page',
               layout: create(:layout, :article, identifier: 'corporate')
      end

      it 'uses the layout in the url' do
        result = PageLink::NextLink.new(first_article).as_json

        expect(result[:title]).to eq('next_page')
        expect(result[:path]).to eq('/en/corporate/next-page')
      end
    end
  end
end
