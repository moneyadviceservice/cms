module PagesHelper
  def dough_component(new_record, components = [])
    new_record ? { dough_component: components.join(' ') } : {}
  end

  def page_type_options_for(site)
    site.layouts.map do |layout|
      [
        layout.label,
        layout.id,
        { 'data-dough-urlformatter-page-type-value' => layout.identifier.pluralize }
      ]
    end
  end

  def page_slug(site_label, slug, page_type_url)
    [
      [preview_domain] <<
      [site_label] <<
      [slug_tag(page_type_url, slug)]
    ].join('/').html_safe
  end

  private

  def preview_domain
    ComfortableMexicanSofa.config.preview_domain
  end

  def slug_tag(page_type_url, slug)
    content_tag(:span, {data: {dough_urlformatter_url_display: true}}) do
      "#{page_type_url}/#{slug}"
    end
  end
end
