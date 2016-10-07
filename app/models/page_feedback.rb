class PageFeedback < ActiveRecord::Base
  belongs_to :page, class: Comfy::Cms::Page
  validates :page, presence: true
end
