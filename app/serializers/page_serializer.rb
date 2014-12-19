require 'active_model_serializers'

class PageSerializer < ActiveModel::Serializer
  attributes :label, :slug, :full_path,
             :meta_description, :meta_title, :category_names,
             :layout_identifier, :related_content

  has_many :blocks, serializer: BlockSerializer

  def related_content
    popular_links = Comfy::Cms::Page.most_popular(3).map do |article|
      {
        title: article.label,
        path: "/en/articles/#{article.slug}"
      }
    end

    { popular_links: popular_links }
  end
end
