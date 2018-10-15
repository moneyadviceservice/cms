class PagePresenter < Presenter
  include ActionView::Helpers::FormTagHelper
  attr_accessor :output_buffer

  def page_type_url
    if identifier
      identifier.pluralize
    else
      'articles'
    end
  end

  def language_input_tag(language, options = {})
    options[:class] ||= 'toggle__control'

    if same_language?(language)
      checked = true
      input_options = input_options_for(object, alternate: options[:alternate])
    else
      mirror = PageMirror.new(object).mirror(language)
      input_options = input_options_for(mirror, alternate: options[:alternate])
    end

    radio_button_tag 'edit-mode', language, checked, options.merge(input_options)
  end

  def language_label_tag(language)
    mirror = PageMirror.new(object).mirror(language)
    label = language.to_s.upcase
    label = "#{label} #{missing_language_icon_tag}" if mirror.blank?

    label_tag("edit-mode_#{language}", label.html_safe, class: 'toggle__label-heading')
  end

  def missing_language_icon_tag
    '<span class="icon-warning fa fa-warning"></span>'
  end

  def last_update
    I18n.l(updated_at, format: :date_with_time)
  end

  def preview_url
    preview_domain = ComfortableMexicanSofa.config.preview_domain
    "#{url_scheme}#{preview_domain}#{link}/preview"
  end

  def link
    "/#{site.label}/#{page_type_url}/#{slug}"
  end

  def category_list
    categories.map(&:label).join(', ')
  end

  private

  def same_language?(language)
    site.label.to_s == language.to_s
  end

  def input_options_for(page, alternate:)
    return { disabled: true } if page.blank?

    { data: { value: url_helpers.edit_site_page_path(page.site, page, alternate: alternate) } }
  end

  def url_scheme
    return 'https://' if Rails.env.production?

    'http://'
  end
end
