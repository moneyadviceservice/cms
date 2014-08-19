class Cms::FormBuilder < ComfortableMexicanSofa::FormBuilder
  def page_rich_text(tag, index)
    @template.render(partial: 'comfy/admin/cms/pages/editor', object: tag.block, 
        locals: {
          index: index, 
          fieldname: field_name_for(tag)
        })
  end
end
