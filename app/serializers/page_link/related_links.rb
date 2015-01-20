module PageLink
  class RelatedLinks < PageLink::Base
    def as_json
      link_collection @page.related_links(3)
    end
  end
end
