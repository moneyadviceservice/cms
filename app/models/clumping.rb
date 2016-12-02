class Clumping < ActiveRecord::Base

  belongs_to :clump
  belongs_to :category, class_name: 'Comfy::Cms::Category'

  validates :clump, presence: true
  validates :category, presence: true
  validates :ordinal, presence: true

  before_validation :set_default_ordinal, on: :create

  def set_default_ordinal
    self.ordinal ||= clump.clumpings.count
  end

end
