require Rails.root.join('lib/comfortable_mexican_sofa/extensions/page')

RSpec.describe Comfy::Cms::Page do

  describe "all_english_articles" do

    it 'does not return english news pages' do
      english_site = FactoryGirl.create :site, label: 'en'
      news_layout = FactoryGirl.create :layout, identifier: 'news'
      news_page = FactoryGirl.create :page, site: english_site, layout: news_layout

      expect(Comfy::Cms::Page.all_english_articles).to be_empty
    end

    it 'does not return welsh article pages' do
      welsh_site = FactoryGirl.create :site, :welsh
      article_layout = FactoryGirl.create :layout, identifier: 'article'
      article_page = FactoryGirl.create :page, site: welsh_site, layout: article_layout

      expect(Comfy::Cms::Page.all_english_articles).to be_empty
    end

    it 'provides english article pages' do
      english_site = FactoryGirl.create :site, label: 'en'
      article_layout = FactoryGirl.create :layout, identifier: 'article'
      article_page = FactoryGirl.create :page, site: english_site, layout: article_layout

      expect(Comfy::Cms::Page.all_english_articles.all).to eq([article_page])
    end

  end

  describe '#update_page_views' do

    let(:analytics) {
      [
        {label: 'first label', page_views: 1000},
        {label: 'how-to-become-a-millionaire', page_views: 500}
      ]
    }

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
      FactoryGirl.create :page, page_views: 100, position: 1
      FactoryGirl.create :page, page_views: 5,   position: 2
      FactoryGirl.create :page, page_views: 200, position: 3
      FactoryGirl.create :page, page_views: 1,   position: 4
      FactoryGirl.create :page, page_views: 152, position: 5
      FactoryGirl.create :page, page_views: 50,  position: 6

      results = Comfy::Cms::Page.most_popular(3)

      expect(results.map(&:page_views)).to eq([200, 152, 100])
    end

  end

end
