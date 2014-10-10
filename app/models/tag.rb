class Tag < ActiveRecord::Base

  # -- Relationships --------------------------------------------------------


  # -- Callbacks ------------------------------------------------------------


  # -- Validations ----------------------------------------------------------
  validates_presence_of   :value
  validates_uniqueness_of :value

  # -- Scopes ---------------------------------------------------------------
  scope :starting_by, ->(start) {where(value: start...start.next).order(:value)}

  # -- Class Methods --------------------------------------------------------


  # -- Instance Methods -----------------------------------------------------


end
