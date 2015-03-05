class CategoryMirror
  def assign_categories_to_mirrors(categories, mirrored_pages)
    mirrored_pages.map do |mirror|
      mirror.categories = categories
      mirror.save
    end
  end
end
