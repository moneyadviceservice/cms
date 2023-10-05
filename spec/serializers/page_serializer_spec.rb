describe PageSerializer do
  let(:site) { Comfy::Cms::Site.new(label: 'en') }
  let(:article) { Comfy::Cms::Page.new(site: site, slug: 'i-am-slug') }
  subject { described_class.new(article) }

  describe 'supports_amp' do
    let(:serialized_page) { build(:page).to_json }
    it 'exposes supports_amp' do
      expect(JSON.parse(serialized_page)).to have_key("supports_amp")
    end
  end

  describe '#full_path' do
    it 'returns /locale/page_type/slug' do
      expect(subject.full_path).to eql('/en/articles/i-am-slug')
    end
  end

  describe '#related_content' do
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
      let!(:article) { create :page, site: english_site, categories: [category] }

      context 'when has previous article' do
        let!(:previous_article) do
          create :page,
                 site:       english_site,
                 label:      'Previous Article',
                 slug:       'previous-article',
                 categories: [category],
                 layout:     create(:layout, :article)
        end

        before :each do
          previous_article.categorizations.first.update_attribute(:ordinal, 1)
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
      let!(:article) { create :page, site: english_site, categories: [category] }

      context 'when has next article' do
        let!(:next_article) do
          create :page,
                 site:       english_site,
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

  describe '#tags' do
    context 'when article has keywords' do
      before { allow(article).to receive(:keywords).and_return(tags) }

      let(:tags) { [build(:tag, value: 'mobile_payments')] }

      it 'returns array of keyword values' do
        expect(subject.tags).to eql(%w[mobile_payments])
      end
    end

    context 'when article has no keywords' do
      it 'returns an empty array' do
        expect(subject.tags).to eql([])
      end
    end
  end
end
