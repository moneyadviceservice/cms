class CategoryPromo < ActiveRecord::Base
  PROMO_TYPES = %w{ blog recommended popular calculator tool }

  belongs_to :category, class: Comfy::Cms::Category

  validates :title, presence: true
  validates :promo_type, inclusion: PROMO_TYPES
  validates :locale, inclusion: %w{ en cy }
end
