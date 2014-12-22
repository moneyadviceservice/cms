require Rails.root.join('lib/cms/update_page_views_task')

RSpec.describe UpdatePageViewsTask do

  describe 'run' do

    it 'updates each english article with google analytics results' do
      google_analytics_results = double('analytics results')
      first_article = Comfy::Cms::Page.new
      second_article = Comfy::Cms::Page.new
      articles = [first_article, second_article]

      allow(GoogleAnalytics::API).
        to receive(:fetch_article_page_views).
        and_return(google_analytics_results)

      allow(Comfy::Cms::Page).
        to receive(:all_english_articles).
        and_return(articles)

      expect(first_article).to receive(:update_page_views).with(google_analytics_results)
      expect(second_article).to receive(:update_page_views).with(google_analytics_results)

      UpdatePageViewsTask.run
    end

  end

end
