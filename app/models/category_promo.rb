class CategoryPromo < ActiveRecord::Base
  PROMO_TYPES = %w{ blog recommended popular calculator tool }

  belongs_to :category, class: Comfy::Cms::Category
end
