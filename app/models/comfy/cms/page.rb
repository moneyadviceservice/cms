require ComfortableMexicanSofa::Engine.root.join('app', 'models', 'comfy', 'cms', 'page.rb')

class Comfy::Cms::Page < ActiveRecord::Base
  scope :most_popular, -> (number_of_items) { unscoped.order('page_views desc').limit(number_of_items) }

  def self.all_english_articles
    joins(:layout)
    .joins(:site)
    .where(
      comfy_cms_sites: { label: 'en' },
      comfy_cms_layouts: { identifier: 'article' }
    )
  end

  def update_page_views(analytics)
    matching_analytic = analytics.find { |analytic| analytic[:label] == slug }
    new_page_views = matching_analytic.present? ? matching_analytic[:page_views] : 0
    update_attribute(:page_views, new_page_views)
  end

  def previous_page
    fetch_adjacent_page do |index|
      index - 1
    end
  end

  def next_page
    fetch_adjacent_page do |index|
      index + 1
    end
  end

  private

  def fetch_adjacent_page
    pages = pages_from_first_category
    return nil if pages.nil?

    page_index = yield pages.index(self)

    fetch_page(pages, page_index)
  end

  def pages_from_first_category
    return nil if categories.empty?

    category = categories.first
    site.pages.for_category(category.label)
  end

  def fetch_page(pages, page_index)
    return nil if page_index < 0 || page_index >= pages.length
    pages[page_index]
  end
end
