class PageFeedback < ActiveRecord::Base
  belongs_to :page, class: Comfy::Cms::Page
  validates :page, :session_id, presence: true
end
