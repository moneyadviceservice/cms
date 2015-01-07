describe PageSerializer do
  let(:site) { Comfy::Cms::Site.new(label: 'en') }
  let(:article) { Comfy::Cms::Page.new(site: site) }
  subject { described_class.new(article) }

  before do
    allow(article).to receive(:previous_article).and_return(nil)
    allow(article).to receive(:next_article).and_return(nil)
  end

  describe '#related_content' do

    context 'popular links' do
      let(:popular_links) do
        subject.related_content[:popular_links]
      end

      before do
        allow(Comfy::Cms::Page)
        .to receive(:most_popular)
        .with(3)
        .and_return(pages)
      end

      context 'when has three most popular articles in english' do
        let(:pages) do
          [
            build(:page, slug: 'first-article', label: 'First Article'),
            build(:page, slug: 'second-article', label: 'Second Article')
          ]
        end

        before do
          site.label = 'en'
        end

        it 'returns english popular links' do
          expect(popular_links).to eq([
            { title: 'First Article', path: '/en/articles/first-article' },
            { title: 'Second Article', path: '/en/articles/second-article' }
          ])
        end
      end

      context 'when has three most popular articles in welsh' do
        let(:pages) do
          [english_article]
        end

        let(:english_article) do
          build(:page, slug: 'first-article-in_english', label: 'First Article in English')
        end

        let(:welsh_article) do
          build(:page, slug: 'first-article-in-welsh', label: 'First Article in Welsh')
        end

        before do
          site.label = 'cy'
          allow(english_article).to receive(:mirrors).and_return([welsh_article])
        end

        it 'returns popular articles in welsh' do
          expect(popular_links).to eq([
            { title: 'First Article in Welsh', path: '/cy/articles/first-article-in-welsh' }
          ])
        end
      end
    end

    context 'when previous link' do
      let(:previous_link) do
        subject.related_content[:previous_link]
      end

      before do
        allow(article).to receive(:previous_page).and_return(previous_article)
      end

      context 'when has previous article' do
        let(:previous_article) do
          build(:page, site: site, label: 'Previous Article', slug: 'previous-article')
        end

        it 'returns article title' do
          expect(previous_link[:title]).to eq('Previous Article')
        end

        it 'returns article path' do
          expect(previous_link[:path]).to eq('/en/articles/previous-article')
        end
      end

      context 'when does not have previous article' do
        let(:previous_article) { nil }

        it 'returns empty previous link' do
          expect(previous_link).to be_empty
        end
      end
    end

    context 'when next link' do
      let(:next_link) do
        subject.related_content[:next_link]
      end

      before do
        allow(article).to receive(:next_page).and_return(next_article)
      end

      context 'when has next article' do
        let(:next_article) do
          build(:page, site: site, label: 'Next Article', slug: 'next-article')
        end

        it 'returns article title' do
          expect(next_link[:title]).to eq('Next Article')
        end

        it 'returns article path' do
          expect(next_link[:path]).to eq('/en/articles/next-article')
        end
      end

      context 'when does not have next article' do
        let(:next_article) { nil }

        it 'returns empty next link' do
          expect(next_link).to be_empty
        end
      end
    end

  end
end
