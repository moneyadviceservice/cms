require_relative '../google_analytics/api'

class UpdatePageViewsTask
  def self.run
    log('Starting UpdatePageViewsTask')
    google_analytics_results = GoogleAnalytics::API.fetch_article_page_views

    Comfy::Cms::Page.all_english_articles.each do |article|
      begin
        article.update_page_views(google_analytics_results)
      rescue
        log("Error updating article: #{article.id} (#{$ERROR_INFO.message})")
      end
    end
    log('Completed UpdatePageViewsTask')
  end

  def self.log(message)
    Rails.logger.info("#{Time.now}: #{message}")
  end
end
