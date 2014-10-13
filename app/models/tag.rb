class Tag < ActiveRecord::Base

  # -- Relationships --------------------------------------------------------
  has_many :taggings


  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------
  validates_presence_of   :value
  validates_uniqueness_of :value
  validates_format_of     :value, :with => /\A[\-a-z0-9 ]+\z/i

  # -- Scopes ---------------------------------------------------------------
  scope :valued,      ->(value) {where(value: value.is_a?(Hash) ? value[:value] : value)}
  scope :starting_by, ->(start) {where("value LIKE ?", "#{start}%").order(:value)}

  # -- Class Methods --------------------------------------------------------

  # -- Instance Methods -----------------------------------------------------
  def in_use?
    taggings.exists?
  end

end
