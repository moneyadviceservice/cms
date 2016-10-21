class PageFeedback < ActiveRecord::Base
  belongs_to :page, class: Comfy::Cms::Page
  validates :page, :session_id, presence: true

  scope :liked,    -> (page_id) { where(page: page_id, liked: true) }
  scope :disliked, -> (page_id) { where(page: page_id, liked: false) }
end
