module PageLink
  class LatestLinks < PageLink::Base
    def as_json
      Rails.cache.fetch('publify_api_latest_links_3', expires_in: 5.minutes) do
        Publify::API.latest_links(3).map do |input_blog_post|
          {
            title: input_blog_post['title'],
            path: input_blog_post['link']
          }
        end
      end
    end
  end
end
