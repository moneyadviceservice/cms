class Clump < ActiveRecord::Base

  has_many :clumpings, -> { order(:ordinal) }, inverse_of: :clump

  # Category model has a default scope on label, so have to override this
  has_many :categories, -> { reorder('clumpings.ordinal ASC') }, through: :clumpings

  has_many :clump_links

  accepts_nested_attributes_for :clump_links

  validates :name_en, presence: true
  validates :name_cy, presence: true
  validates :description_en, presence: true
  validates :description_cy, presence: true
  validates :ordinal, presence: true

  default_scope { order(:ordinal) }

  before_validation :set_default_ordinal, on: :create

  def set_default_ordinal
    self.ordinal ||= Clump.count
  end

end
