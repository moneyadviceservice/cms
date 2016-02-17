RSpec.describe Comfy::Cms::Page do
  describe '#suppress_from_links_recirculation' do
    let(:english_site) { create :site, is_mirrored: true }
    let(:welsh_site) { create :site, :welsh, is_mirrored: true }

    let!(:english_article) do
      create :english_article,
             full_path:  '/animals',
             site: english_site
    end
    let!(:welsh_article) do
      create :welsh_article,
             full_path:  '/animals',
             site: welsh_site
    end

    context 'update welsh article when updating english article' do
      before do
        english_article.suppress_from_links_recirculation = supressed?
        english_article.suppress_mirrors_from_links_recirculation
        welsh_article.reload
      end

      context 'when english article supressed' do
        let(:supressed?) { true }

        it 'welsh article should be supressed' do
          expect(welsh_article.suppress_from_links_recirculation).to be_truthy
        end
      end

      context 'when english article not supressed' do
        let(:supressed?) { false }

        it 'welsh article should not be supressed' do
          expect(welsh_article.suppress_from_links_recirculation).to be_falsey
        end
      end
    end

    context 'update english article when updating welsh article' do
      before do
        welsh_article.suppress_from_links_recirculation = supressed?
        welsh_article.suppress_mirrors_from_links_recirculation
        english_article.reload
      end

      context 'when welsh article supressed' do
        let(:supressed?) { true }

        it 'english article should be supressed' do
          expect(english_article.suppress_from_links_recirculation).to be_truthy
        end
      end

      context 'when welsh article not supressed' do
        let(:supressed?) { false }

        it 'english article should not be supressed' do
          expect(english_article.suppress_from_links_recirculation).to be_falsey
        end
      end
    end
  end

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

    context 'ignores suppressed articles' do
      let(:animals_tag) { Tag.create value: 'animals' }
      let!(:animals_article) { create :english_article, keywords: [animals_tag] }
      let!(:suppressed_english_article) do
        create :english_article,
               keywords: [animals_tag],
               suppress_from_links_recirculation: true
      end
      let!(:not_suppressed_match_article) do
        create :english_article,
               keywords: [animals_tag],
               suppress_from_links_recirculation: false
      end

      it 'order by most matching tags' do
        expect(animals_article.related_links(2)).to eq([not_suppressed_match_article])
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

    context 'when articles have zero page views' do
      before do
        create :page, page_views: 1, position: 1
        create :page, page_views: 0, position: 2
        create :page, page_views: 0, position: 3
      end

      it 'does not return articles with zero page_views' do
        results = Comfy::Cms::Page.most_popular(3)

        expect(results.map(&:page_views)).to eq([1])
      end
    end

    context 'when there are suppressed articles' do
      let!(:first_suppressed_page) { create :page, page_views: 200, suppress_from_links_recirculation: true }
      let!(:first_not_suppressed_page) { create :page, page_views: 1, suppress_from_links_recirculation: false }
      let!(:second_not_suppressed_page) { create :page, page_views: 150, suppress_from_links_recirculation: false }
      let!(:second_suppressed_page) { create :page, page_views: 50, suppress_from_links_recirculation: true }

      it 'ignores them' do
        results = Comfy::Cms::Page.most_popular(3)

        expect(results).to eq([second_not_suppressed_page, first_not_suppressed_page])
      end
    end
  end

  describe 'has ever been published' do
    let(:page) { create(:page) }

    context 'when there is a previous published event' do
      before { page.revisions.create!(data: { event: 'published' }) }

      it 'when it has been published' do
        expect(page.ever_been_published?).to be_truthy
      end
    end

    it 'when it has not been published' do
      expect(page.ever_been_published?).to be_falsey
    end
  end

  describe '#publishable?' do
    context 'when tagged with do-not-publish' do
      it 'returns false' do
        allow(subject).to receive(:keywords) { [Tag.new(value: 'do-not-publish')] }
        expect(subject).to_not be_publishable
      end
    end

    it 'returns true' do
      allow(subject).to receive(:keywords) { [Tag.new(value: 'a-tag')] }
      expect(subject).to be_publishable
    end
  end

  describe '#published_at' do
    let(:site) { create(:site) }
    let(:layout) { create(:layout) }

    subject do
      described_class.create!(site: site, layout: layout, label: 'this is my page')
    end

    context 'when saving the record' do
      it 'does not affect the published_at field' do
        subject.label = 'new label'
        expect { subject.save! }.to_not change(subject, :published_at)
      end
    end

    context 'when draft' do
      it 'is nil' do
        subject.create_initial_draft
        expect(subject.published_at).to be_nil
      end
    end

    context 'when published' do
      it 'sets the published_at stamp' do
        subject.create_initial_draft
        subject.publish
        expect(subject.published_at).to_not be_nil
      end
    end

    context 'scheduled' do
      it 'leaves published_at stamp' do
        subject.create_initial_draft
        subject.publish
        expect {
          subject.create_new_draft
          subject.schedule
        }.to_not change(subject, :published_at)
      end
    end

    context 'been unpublished' do
      it 'leaves published_at stamp' do
        subject.create_initial_draft
        subject.publish
        expect { subject.unpublish }.to_not change(subject, :published_at)
      end
    end
  end
end
