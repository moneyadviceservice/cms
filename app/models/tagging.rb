class Tagging < ActiveRecord::Base
  # -- Relationships --------------------------------------------------------
  belongs_to :taggable, polymorphic: true
  belongs_to :tag

  # -- Callbacks ------------------------------------------------------------

  # -- Validations ----------------------------------------------------------
  validates_presence_of :tag_id, :taggable_id, :taggable_type
  validates_uniqueness_of :tag_id, scope: [:taggable_id, :taggable_type]

  # -- Scopes ---------------------------------------------------------------

  # -- Class Methods --------------------------------------------------------

  # -- Instance Methods -----------------------------------------------------
end
