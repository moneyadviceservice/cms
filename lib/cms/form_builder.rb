class Cms::FormBuilder < ComfortableMexicanSofa::FormBuilder
  def page_rich_text(tag, index)
    @template.render(partial: 'comfy/admin/cms/pages/editor', object: tag.block,
        locals: {
          index: index,
          fieldname: field_name_for(tag)
        })
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
end
