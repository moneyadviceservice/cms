class Tagging < ActiveRecord::Base
  # -- Relationships --------------------------------------------------------
  belongs_to :taggable, polymorphic: true
  belongs_to :tag

  # -- Callbacks ------------------------------------------------------------

  # -- Validations ----------------------------------------------------------
  validates :tag_id, :taggable_id, :taggable_type, presence: true
  validates :tag_id, uniqueness: { scope: %i[taggable_id taggable_type] }

  # -- Scopes ---------------------------------------------------------------

  # -- Class Methods --------------------------------------------------------

  # -- Instance Methods -----------------------------------------------------
end
