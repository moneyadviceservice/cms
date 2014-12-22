require ComfortableMexicanSofa::Engine.root.join('app', 'models', 'comfy', 'cms', 'page.rb')

class Comfy::Cms::Page < ActiveRecord::Base
  def self.find_by_url(url)
    paths = Comfy::Cms::Site.pluck(:path).reject(&:blank?)
    slug = url.sub(/#{paths.join('|')}/, '').sub('articles', '').squeeze('/').gsub(/\A\//, '')

    Comfy::Cms::Page.where(slug: slug).take
  end
end
