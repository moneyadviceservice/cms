require_dependency ComfortableMexicanSofa::Engine.root.join('app', 'models', 'comfy', 'cms', 'page.rb')
require Rails.root.join('lib', 'comfortable_mexican_sofa', 'extensions', 'is_taggable')

class Comfy::Cms::Page < ActiveRecord::Base
  include ComfortableMexicanSofa::IsTaggable::ModelMethods

  has_many :feedbacks,
           class_name: PageFeedback,
           foreign_key: 'page_id',
           dependent: :destroy

  delegate :identifier, to: :layout, allow_nil: true
  alias_method :translations, :mirrors

  scope :ignore_suppressed, -> { where(suppress_from_links_recirculation: false) }

  scope :most_popular, (lambda do |number_of_items|
    unscoped
      .where.not(page_views: 0)
      .order('page_views desc')
      .ignore_suppressed
      .limit(number_of_items)
  end)

  scope :in_locale, -> (locale) { joins(:site).where('comfy_cms_sites.label' => locale) }

  scope :with_tags, -> (tags) { joins(:taggings).where('taggings.tag_id' => tags.map(&:id)) }

  scope :remove_self_from_results, -> (page) { where.not(id: page.id) }

  scope :sort_by_tag_similarity, (lambda do |keywords|
    with_tags(keywords)
      .group('comfy_cms_pages.id')
      .order('COUNT(*) DESC, comfy_cms_pages.page_views DESC')
    # This counts the number of tags each article has in common
    # with the article we're querying against,
    # then sorts by that number, then the page views.
  end)

  scope :all_english_articles, (lambda do
    joins(:layout)
      .joins(:site)
      .where(
        comfy_cms_sites: { label: 'en' },
        comfy_cms_layouts: { identifier: 'article' }
      )
  end)

  scope :unpublished, -> { where(state: 'unpublished') }

  scope :layout_identifier, (lambda do |identifier|
    joins(:layout).where(comfy_cms_layouts: { identifier: identifier.singularize })
  end)

  def self.in_category(category_id)
    joins(
      'INNER JOIN comfy_cms_categorizations
       ON comfy_cms_categorizations.categorized_id = comfy_cms_pages.id'
    )
      .where('comfy_cms_categorizations.category_id = ?', category_id)
      .reorder('comfy_cms_categorizations.ordinal ASC')
  end

  def translation
    mirrors.first
  end

  def update_page_views(analytics)
    matching_analytic = analytics.find { |analytic| analytic[:label] == slug }
    new_page_views = matching_analytic.present? ? matching_analytic[:page_views] : 0
    update_attribute(:page_views, new_page_views)
  end

  def related_links(limit)
    mirrored_page = PageMirror.new(self).mirror(:en)

    Comfy::Cms::Page
      .unscoped
      .all_english_articles
      .ignore_suppressed
      .sort_by_tag_similarity(keywords)
      .remove_self_from_results(self)
      .where.not(id: mirrored_page.try(:id))
      .limit(limit)
  end

  def mirror_suppress_from_links_recirculation!
    mirrors.map do |mirror|
      mirror.update_attribute(:suppress_from_links_recirculation, suppress_from_links_recirculation)
    end
  end

  def mirror_categories!
    mirrors.map do |mirror|
      mirror.update_attribute(:categories, categories)
    end
  end

  def ever_been_published?
    revisions.map { |revision| revision.data[:event] }.include?('published')
  end

  def publishable?
    keywords.all?(&:publishable?)
  end

  def fullest_path
    "/#{site.label}/#{layout.identifier.pluralize}/#{slug}"
  end
end
