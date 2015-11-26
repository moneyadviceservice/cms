module PagesHelper
  def tag_for_identifier(tags, identifier, cms_blocks, index)
    tag = tags.find { |t| t.identifier == identifier }
    cms_blocks.send(tag.class.to_s.demodulize.underscore, tag, index)
  end

  def page_form_component(condition, default: [], optional: [], display: true)
    return {} unless display
    { dough_component: components(condition, default, optional).join(' ') }
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

  def components(condition, default, optional)
    if condition
      [default, optional].flatten
    else
      default
    end
  end
end
