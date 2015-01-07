require 'active_model_serializers'

class PageSerializer < ActiveModel::Serializer
  attributes :label, :slug, :full_path,
             :meta_description, :meta_title, :category_names,
             :layout_identifier, :related_content

  has_many :blocks, serializer: BlockSerializer

  def related_content
    {
      popular_links: popular_links,
      previous_link: previous_link,
      next_link: next_link
    }
  end

  private

  def current_locale
    object.site.label
  end

  def popular_links
    Comfy::Cms::Page.most_popular(3).map do |article|
      article = article.mirrors.first if current_locale == 'cy'
      build_json_link article
    end
  end

  def previous_link
    return {} if object.previous_page.nil?
    build_json_link object.previous_page
  end

  def next_link
    return {} if object.next_page.nil?
    build_json_link object.next_page
  end

  def build_json_link(page)
    {
      title: page.label,
      path: "/#{current_locale}/articles/#{page.slug}"
    }
  end
end
