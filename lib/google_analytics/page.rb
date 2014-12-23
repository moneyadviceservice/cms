module GoogleAnalytics
  class Page
    extend Legato::Model

    metrics :pageviews
    dimensions :page_path

    def self.popular_articles(profile)
      popular_pages = results(profile, start_date: 1.week.ago, end_date: Time.now, sort: '-pageviews', limit: 10_000)
      popular_pages
        .select { |page| page.pagePath =~ /\A\/en\/articles\/[\w-]+/i }
        .map { |p| { page_views: p.pageviews.to_i, label: label(p.pagePath) } }
    end

    def self.label(url)
      match_data = url.match(/\A\/en\/articles\/([\w-]+)/i)
      match_data.captures.first
    end
  end
end
