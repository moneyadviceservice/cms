module PageLink
  class PopularLinks < PageLink::Base
    def as_json
      link_collection Comfy::Cms::Page.most_popular(3)
    end
  end
end
