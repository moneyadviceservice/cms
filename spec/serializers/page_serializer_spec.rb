describe PageSerializer do
  let(:site) { Comfy::Cms::Site.new(label: 'en') }
  let(:article) { Comfy::Cms::Page.new(site: site, slug: 'i-am-slug') }
  subject { described_class.new(article) }

  before do
    allow(article).to receive(:previous_article).and_return(nil)
    allow(article).to receive(:next_article).and_return(nil)
    allow(article).to receive(:related_links).and_return([])
    allow(Publify::API).to receive(:latest_links).and_return([])
  end

  describe '#full_path' do
    it 'returns /locale/page_type/slug' do
      expect(subject.full_path).to eql('/en/articles/i-am-slug')
    end
  end

  describe '#related_content' do
    context 'latest blog post links' do
      let(:latest_links) do
        [
          { 'title' => 'First post', 'link' => 'http://a.com' },
          { 'title' => 'Second post', 'link' => 'http://b.com' },
          { 'title' => 'Third post', 'link' => 'http://c.com' }
        ]
      end

      before do
        allow(Publify::API).to receive(:latest_links).with(3).and_return(latest_links)
      end

      it 'maps the 3 latest links' do
        result = subject.related_content[:latest_blog_post_links].as_json
        expect(result.length).to eq(3)
      end

      it 'maps the latest links correctly' do
        result = subject.related_content[:latest_blog_post_links].as_json

        expect(result.first).to eq(
          title: 'First post',
          path: 'http://a.com'
        )
      end

    end

    context 'related links' do
      let(:related_links) do
        subject.related_content[:related_links].as_json
      end

      before do
        allow(article)
        .to receive(:related_links)
        .with(3)
        .and_return(pages)
      end

      context 'when has most related articles in english' do
        let(:pages) do
          [
            build(:page,
                  slug: 'first-article',
                  label: 'First Article',
                  layout: build(:layout, :article)),
            build(:page,
                  slug: 'second-article',
                  label: 'Second Article',
                  layout: build(:layout, :article))
          ]
        end

        before do
          site.label = 'en'
        end

        it 'returns english related links' do
          expect(related_links).to eq([
            { title: 'First Article', path: '/en/articles/first-article' },
            { title: 'Second Article', path: '/en/articles/second-article' }
          ])
        end
      end

      context 'when has most related articles in welsh' do
        let(:pages) do
          [english_article]
        end

        let(:english_article) do
          build(:page,
                slug: 'english-article',
                label: 'English Article',
                layout: build(:layout),
                site: build(:site))
        end

        let(:welsh_article) do
          build(:page,
                slug: 'welsh-article',
                label: 'Welsh Article',
                site: build(:site, :welsh),
                layout: build(:layout, :article))
        end

        before do
          site.label = 'cy'
          allow(english_article).to receive(:mirrors).and_return([welsh_article])
        end

        it 'returns welsh related links' do
          expect(related_links).to eq([
            { title: 'Welsh Article', path: '/cy/articles/welsh-article' }
          ])
        end
      end
    end

    context 'popular links' do
      let(:popular_links) do
        subject.related_content[:popular_links].as_json
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
            build(:page,
                  slug: 'first-article',
                  label: 'First Article',
                  layout: build(:layout, :article)),
            build(:page,
                  slug: 'second-article',
                  label: 'Second Article',
                  layout: build(:layout, :article))
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
          build(:page,
                slug: 'first-article-in_english',
                label: 'First Article in English',
                site: build(:site),
                layout: build(:layout, :article))
        end

        let(:welsh_article) do
          build(:page,
                slug: 'first-article-in-welsh',
                label: 'First Article in Welsh',
                layout: build(:layout, :article),
                site: build(:site, :welsh))
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
        subject.related_content[:previous_link].as_json
      end

      let(:english_site) { create :site }
      let(:welsh_site) { create :site, :welsh }
      let(:category) { create :category }
      let!(:article) { create :page, position: 1, site: english_site, categories: [category] }

      context 'when has previous article' do
        let!(:previous_article) do
          create :page,
                 position:   0,
                 site:       english_site,
                 label:      'Previous Article',
                 slug:       'previous-article',
                 categories: [category],
                 layout:     create(:layout, :article)
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
        subject.related_content[:next_link].as_json
      end

      let(:english_site) { create :site }
      let(:welsh_site) { create :site, :welsh }
      let(:category) { create :category }
      let!(:article) { create :page, position: 1, site: english_site, categories: [category] }

      context 'when has next article' do
        let!(:next_article) do
          create :page,
                 site:       english_site,
                 position:   2,
                 label:      'Next Article',
                 slug:       'next-article',
                 categories: [category],
                 layout:     create(:layout, :article)
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
