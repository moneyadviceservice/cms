require 'net/http'

module Publify
  class API
    def self.latest_links(limit)
      connection = Net::HTTP.new(ENV['PUBLIFY_HOSTNAME'], ENV['PUBLIFY_PORT'].to_i)
      connection.open_timeout = 2
      connection.read_timeout = 2
      connection.use_ssl = ENV['PUBLIFY_USE_SSL'] == 'true'
      response = connection.get('/articles.json')
      JSON.parse(response.body).first(limit)
    rescue => e
      Rails.logger.error(e.message)
      []
    end
  end
end
