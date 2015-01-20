RSpec.describe Comfy::Cms::Page do

  describe '#related_links' do
    let(:animals_tag) { Tag.create value: 'animals' }
    let(:cheese_tag) { Tag.create value: 'cheese' }
    let(:animals_article) { create :english_article, keywords: [animals_tag] }

    context 'the more matching tags, the closer the match' do
      context 'single keyword' do
        it 'provides an empty array when no matching articles exist' do
          expect(animals_article.related_links(1)).to be_empty
        end

        it 'provides one matching articles based on single keyword' do
          related_animal_article = create :english_article, keywords: [animals_tag]
          create :english_article, keywords: [cheese_tag]

          expect(animals_article.related_links(2)).to eq([related_animal_article])
        end
      end

      context 'two keywords' do
        let(:dog_tag) { Tag.create value: 'dog' }
        let!(:animals_article) { create :english_article, keywords: [animals_tag, dog_tag] }

        it 'order by most matching tags' do
          one_tag_match_article = create :english_article, keywords: [animals_tag]
          all_tag_match_article = create :english_article, keywords: [animals_tag, dog_tag], page_views: 2

          expect(animals_article.related_links(2)).to eq([all_tag_match_article, one_tag_match_article])
        end
      end
    end

    context 'page_view ordering matches' do
      it 'orders by page_view' do
        related_unpopular_article = create :english_article, keywords: [animals_tag], page_views: 1
        related_popular_article = create :english_article, keywords: [animals_tag], page_views: 2

        expect(animals_article.related_links(2)).to eq([related_popular_article, related_unpopular_article])
      end
    end

    context 'when finding a welsh article' do
      let(:layout) { create :layout }
      let!(:english_article) do
        create :english_article,
               keywords:   [animals_tag],
               page_views: 5,
               full_path:  '/animals',
               layout:     layout
      end
      let(:welsh_animal_article) do
        create :welsh_article,
               keywords:   [animals_tag],
               page_views: 2,
               full_path:  '/animals',
               layout:     layout
      end

      it 'excludes the alternate english version from the results' do
        related_article = create :english_article, keywords: [animals_tag], page_views: 1, full_path: 'something else'
        expect(welsh_animal_article.related_links(2)).to eq([related_article])
      end
    end

    context 'in a site with non-English articles' do
      it 'should not return non-English articles' do
        welsh_animal_article = create :welsh_article, keywords: [animals_tag], page_views: 2
        related_article = create :english_article, keywords: [animals_tag], page_views: 1
        create :welsh_article, keywords: [animals_tag], page_views: 1

        expect(welsh_animal_article.related_links(2)).to eq([related_article])
      end
    end

    context 'limit' do
      it 'limits to provided limit' do
        create :english_article, keywords: [animals_tag], page_views: 1
        related_popular_article = create :english_article, keywords: [animals_tag], page_views: 2

        expect(animals_article.related_links(1)).to eq([related_popular_article])
      end
    end

  end

  describe 'all_english_articles' do
    it 'does not return english news pages' do
      english_site = create :site, label: 'en'
      news_layout = create :layout, identifier: 'news'
      create :page, site: english_site, layout: news_layout

      expect(Comfy::Cms::Page.all_english_articles).to be_empty
    end

    it 'does not return welsh article pages' do
      welsh_site = create :site, :welsh
      article_layout = create :layout, identifier: 'article'
      create :page, site: welsh_site, layout: article_layout

      expect(Comfy::Cms::Page.all_english_articles).to be_empty
    end

    it 'provides english article pages' do
      english_site = create :site, label: 'en'
      article_layout = create :layout, identifier: 'article'
      article_page = create :page, site: english_site, layout: article_layout

      expect(Comfy::Cms::Page.all_english_articles.all).to eq([article_page])
    end

  end

  describe '#update_page_views' do
    let(:analytics) do
      [
        { label: 'first label', page_views: 1000 },
        { label: 'how-to-become-a-millionaire', page_views: 500 }
      ]
    end

    it 'updates page with views from analytics' do
      subject = Comfy::Cms::Page.new(page_views: 200, slug: 'how-to-become-a-millionaire')
      expect(subject).to receive(:update_attribute).with(:page_views, 500)

      subject.update_page_views(analytics)
    end

    it 'zeros page_views when not in analytics' do
      subject = Comfy::Cms::Page.new(page_views: 300, slug: 'not-in-analytics')
      expect(subject).to receive(:update_attribute).with(:page_views, 0)

      subject.update_page_views(analytics)
    end
  end

  describe '#most_popular scope' do

    it 'has the three most popular articles' do
      create :page, page_views: 100, position: 1
      create :page, page_views: 5,   position: 2
      create :page, page_views: 200, position: 3
      create :page, page_views: 1,   position: 4
      create :page, page_views: 152, position: 5
      create :page, page_views: 50,  position: 6

      results = Comfy::Cms::Page.most_popular(3)

      expect(results.map(&:page_views)).to eq([200, 152, 100])
    end

  end

end
