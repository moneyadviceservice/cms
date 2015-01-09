require 'net/http'

module Publify
  class API
    def self.latest_links(limit)
      uri = URI("http://#{ENV['PUBLIFY_HOSTNAME']}/articles.json")
      response = Net::HTTP.get uri
      JSON.parse(response).first(limit)
    rescue => e
      Rails.logger.error(e.message)
      []
    end
  end
end
