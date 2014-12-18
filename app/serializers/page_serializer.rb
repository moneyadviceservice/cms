require 'active_model_serializers'

class PageSerializer < ActiveModel::Serializer
  attributes :label, :slug, :full_path,
             :meta_description, :meta_title, :category_names,
             :layout_identifier, :related_content

  has_many :blocks, serializer: BlockSerializer

  def related_content
    { popular_links: [{ title: 'Sharky', path: '/cheese' },
                      { title: 'George', path: '/wine' }] }
  end
end
