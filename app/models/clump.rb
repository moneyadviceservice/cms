class Clump < ActiveRecord::Base

  has_many :clumpings, -> { order(:ordinal) }, inverse_of: :clump
  has_many :categories, through: :clumpings

  validates :name_en, presence: true
  validates :name_cy, presence: true
  validates :description_en, presence: true
  validates :description_cy, presence: true
  validates :ordinal, presence: true

  default_scope { order(:ordinal) }

end
