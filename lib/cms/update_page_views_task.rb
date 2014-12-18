require_relative '../google_analytics/api'

class UpdatePageViewsTask
  def self.run
    google_analytics_results = GoogleAnalytics::API.fetch_article_page_views

    Comfy::Cms::Page.all_english_articles.each do |article|
      article.update_page_views google_analytics_results
    end
  end
end
