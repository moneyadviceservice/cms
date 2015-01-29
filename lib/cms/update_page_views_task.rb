require_relative '../google_analytics/api'

class UpdatePageViewsTask
  def self.run
    logger.info('Starting UpdatePageViewsTask')
    google_analytics_results = GoogleAnalytics::API.fetch_article_page_views

    Comfy::Cms::Page.all_english_articles.each do |article|
      begin
        logger.info("Updating article: #{article.id} : #{article.slug}")
        article.update_page_views(google_analytics_results)
      rescue
        logger.error("Could not update article: #{article.id} : #{article.slug} : (#{$ERROR_INFO.message})")
      end
    end
    logger.info('Completed UpdatePageViewsTask')
  end

  def self.logger
    Rails.logger
  end
end
