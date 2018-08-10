module PagesHelper
  def fields_from_layout(comfortable_mexican_sofa_tag)
    Cms::LayoutField.map(comfortable_mexican_sofa_tag['default'])
  end

  def tag_for_identifier(tags, identifier, cms_blocks, index)
    tag = tags.find { |t| t.identifier == identifier }
    cms_blocks.send(tag.class.to_s.demodulize.underscore, tag, index)
  end

  def content_field(tags, cms_blocks)
    tag = tags.find { |t| t.identifier == 'content' }
    tag_index = tags.index { |t| t.identifier == 'content' }
    cms_blocks.send(tag.class.to_s.demodulize.underscore, tag, tag_index)
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

  def display_additional_button_menu?(page, user)
    !(user.editor? || page.unsaved? || page.unpublished?)
  end

  def display_metadata_form_fields?(page)
    !page.layout.identifier.in?(%w[home_page footer])
  end

  def activity_log(page)
    ActivityLogPresenter.collect(ActivityLog.fetch(from: page))
  end

  def categories
    @categories ||= Comfy::Cms::CategoriesListPresenter.new(Comfy::Cms::Category.where(site: english_site))
  end

  def main_status(page)
    current_status(page).split(/\ \|\ /)[0]
  end

  def alternate_status(page)
    current_status(page).split(/\ \|\ /)[1]
  end

  def scheduled_time(page)
    if page.scheduled_on.today?
      page.scheduled_on.strftime('%H:%M today')
    else
      if page.scheduled_on.year == Date.today.year
        page.scheduled_on.strftime('%H:%M %a %-d %b')
      else
        page.scheduled_on.strftime('%H:%M %a %-d %b %Y')
      end
    end
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
