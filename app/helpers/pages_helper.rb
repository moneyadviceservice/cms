module PagesHelper
  def dough_component(new_record, components = [])
    new_record ? {dough_component: components.join(" ")} : {}
  end
end
