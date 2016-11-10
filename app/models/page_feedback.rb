class PageFeedback < ActiveRecord::Base
  belongs_to :page, class: Comfy::Cms::Page
  validates :page, :session_id, presence: true
  validates :shared_on, inclusion: { in: %w(Facebook Twitter Email) }, allow_blank: true

  scope :liked,    -> (page_id) { where(page: page_id, liked: true) }
  scope :disliked, -> (page_id) { where(page: page_id, liked: false) }

  delegate :slug, to: :page, prefix: true

  CSV_COLUMNS = ['page_slug', column_names].flatten

  def self.to_csv(_ = {})
    CSV.generate do |csv|
      csv << CSV_COLUMNS

      find_each do |page_feedback|
        csv << CSV_COLUMNS.map { |column| page_feedback.send(column) }
      end
    end
  end
end
