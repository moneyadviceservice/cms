require_relative 'link_type/tools'
require_relative 'link_type/action_plans'
require_relative 'link_type/news'
require_relative 'link_type/static'
require_relative 'link_type/videos'
require_relative 'link_type/welsh'
require_relative 'link_type/external'

class LinkLookup
  def find(link, site = 'en')
    [LinkType::Tools::LINKS,
     LinkType::ActionPlans::LINKS,
     LinkType::News::LINKS,
     LinkType::Static::LINKS,
     LinkType::Videos::LINKS,
     LinkType::Welsh::LINKS].map do |type|
      type.find { |e| e.match(link) }
    end.compact.first || "/#{site}/articles/#{link}"
  end

  def find_external(id, site = :en)
    link = LinkType::External::LINKS[id]
    [link[:url], link[site]]
  end
end
