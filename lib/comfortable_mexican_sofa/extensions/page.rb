class Comfy::Cms::Page

  def self.all_english_articles
    joins(:layout).
    joins(:site).
    where(
      comfy_cms_sites: {label: 'en'},
      comfy_cms_layouts: { identifier: 'article' }
    )
  end

  def update_page_views(analytics)
    matching_analytic = analytics.find {|analytic| analytic[:label] == self.slug }
    new_page_views = matching_analytic.present? ? matching_analytic[:page_views] : 0
    update_attribute(:page_views, new_page_views)
  end

end