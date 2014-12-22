require 'active_model_serializers'

class PageSerializer < ActiveModel::Serializer
  attributes :label, :slug, :full_path,
             :meta_description, :meta_title, :category_names,
             :layout_identifier, :related_content

  has_many :blocks, serializer: BlockSerializer

  def related_content
    popular_links = Comfy::Cms::Page.most_popular(3).map do |article|
      current_locale = object.site.label
      article = article.mirrors.first if current_locale == 'cy'

      {
        title: article.label,
        path: "/#{current_locale}/articles/#{article.slug}"
      }
    end

    { popular_links: popular_links }
  end
end
