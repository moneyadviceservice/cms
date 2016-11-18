class Clumping < ActiveRecord::Base

  belongs_to :clump
  belongs_to :category, class_name: 'Comfy::Cms::Category'

  validates :clump, presence: true
  validates :category, presence: true
  validates :ordinal, presence: true

end
