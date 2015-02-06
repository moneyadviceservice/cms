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
end
