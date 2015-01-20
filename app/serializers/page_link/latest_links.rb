module PageLink
  class LatestLinks < PageLink::Base
    def as_json
      Publify::API.latest_links(3).map do |input_blog_post|
        {
          title: input_blog_post['title'],
          path: input_blog_post['link'],
          date: input_blog_post['pubDate']
        }
      end
    end
  end
end
