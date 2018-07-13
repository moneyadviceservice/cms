require 'active_model_serializers'

class PageSerializer < ActiveModel::Serializer
  attributes :label, :slug, :full_path,
             :meta_description, :meta_title, :category_names,
             :layout_identifier, :related_content, :published_at, :supports_amp,
             :tags

  has_many :blocks, serializer: BlockSerializer
  has_many :translations, serializer: PageTranslationSerializer

  def full_path
    PagePresenter.new(object).link
  end

  def related_content
    {
      latest_blog_post_links: PageLink::LatestLinks.new(object),
      popular_links: PageLink::PopularLinks.new(object),
      related_links: PageLink::RelatedLinks.new(object),
      previous_link: PageLink::PreviousLink.new(object),
      next_link: PageLink::NextLink.new(object)
    }
  end

  def tags
    object.keywords.map(&:value)
  end
end
