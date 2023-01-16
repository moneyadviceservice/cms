class Cms::FormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::FormTagHelper

  def collection_check_boxes(tag, index)
    current_values = blocks_attributes.select do |block|
      block['identifier'] == tag.identifier
    end.map { |block| block['content'] }

    element = tag.element
    checked = tag.element.in?(current_values)

    @template.render(
      template: 'collection_check_boxes/show',
      locals: {
        tag: tag,
        index: index,
        element: element,
        checked: checked
      }
    )
  end

  def simple_component(tag, index)
    default_tag_field(
      tag,
      index,
      :text_area_tag,
      placeholder: tag.params,
      class: tag.identifier,
      rows: 4
    )
  end

  def page_image(tag, index)
    markup = <<-eos
      <div class="form-group form-image"
           data-dough-component="FormImage"
           data-dough-form-image-identifier="home-edit-field-#{index}">
      #{default_tag_field(tag, index, :text_field_tag, data: { 'dough-form-image-input' => '' })}
      <div class="form-image__preview-wrapper"><div class="form-image__preview"></div></div>
      <button class="button--action form-image__button"
              data-dough-component="Dialog"
              data-dough-dialog-context="insert-image"
              data-dough-dialog-identifier="home-edit-field-#{index}"
              type="button"><span class="button__text">Select image</span></button>
      <button class="button--action form-image__button--remove"
              type="button"><span class="button__text">Remove</span></button>
      </div>
    eos

    markup.html_safe
  end

  private

  def blocks_attributes
    object
  end

  def page_rich_text(tag, index)
    @template.render(partial: 'comfy/admin/cms/pages/editor', object: tag.block,
                     locals: {
                       index: index,
                       fieldname: field_name_for(tag)
                     })
  end

  def page_text(tag, index)
    default_tag_field(tag, index, :text_area_tag, :data => { 'cms-cm-mode' => 'text/html' })
  end

  def page_string(tag, index)
    default_tag_field(tag, index)
  end

  def field_date_time(tag, index)
    default_tag_field(
      tag,
      index,
      :date_field_tag,
      data: { 'cms-datetime' => true }
    )
  end

  def field_string(tag, index)
    default_tag_field(tag, index)
  end

  def field_text(tag, index)
    default_tag_field(tag, index)
  end

  def field_name_for(tag)
    tag.blockable.class.name.demodulize.underscore.gsub(/\//, '_')
  end

  # This is overriding comfy with an almost identical method, just that the
  # name attributes are different - "blocks_attributes[#{index}]" instead of
  # "#{fieldname}[blocks_attributes][#{index}]".
  #
  # This is because we handle the block attributes independently from the page
  # attributes in forms.
  def default_tag_field(tag, index, method = :text_field_tag, options = {})
    label       = tag.blockable.class.human_attribute_name(tag.identifier.to_s)
    content     = ''
    current_value = find_current_value_for_field(tag)

    case method
    when :file_field_tag
      input_params = { :id => nil, value: current_value }
      name = "blocks_attributes[#{index}][content]"

      if options.delete(:multiple)
        input_params.merge!(:multiple => true)
        name << '[]'
      end

      content << @template.send(method, name, input_params)
      content << @template.render(:partial => 'comfy/admin/cms/files/page_form', :object => tag.block)
    else
      options[:class] ||= 'form-control'
      content << @template.send(method, "blocks_attributes[#{index}][content]", current_value.to_s.gsub(/\n/, ''), options)
    end
    content << @template.hidden_field_tag("blocks_attributes[#{index}][identifier]", tag.identifier, :id => nil)
    content.prepend(@template.label_tag(label))

    content.html_safe
  end

  def find_current_value_for_field(tag)
    current_field = blocks_attributes.find do |block_attributes|
      block_attributes[:identifier] == tag.identifier.to_s
    end

    if current_field.present?
      current_field[:content]
    else
      ''
    end
  end
end
