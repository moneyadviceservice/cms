require 'httparty'

module Publify
  class API
    def self.latest_links(limit)
      response = HTTParty.get(
        ENV['MAS_BLOG_URL'] + '/articles.json',
        timeout: 2,
        verify: MAS.env.production?
      )
      JSON.parse(response.body).first(limit)
    rescue StandardError => e
      Rails.logger.error(e.message)
      []
    end
  end
end
