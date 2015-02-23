module PagesHelper
  def page_form_component(page, default: [], optional: [])
    components = if page.new_record?
                   [default, optional].flatten
                 else
                   default
                 end

    { dough_component: components.join(' ') }
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

  def page_slug(site_label, page_type_url, slug)
    [
      preview_domain,
      site_label,
      slug_tag(page_type_url, slug)
    ].join('/').html_safe
  end

  private

  def preview_domain
    ComfortableMexicanSofa.config.preview_domain
  end

  def slug_tag(page_type_url, slug)
    content_tag(:span, data: { dough_urlformatter_url_display: true }) do
      "#{page_type_url}/#{slug}"
    end
  end
end
