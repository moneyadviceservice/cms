class PageFeedback < ActiveRecord::Base
  belongs_to :page, class_name: Comfy::Cms::Page
  validates :page, :session_id, presence: true
  validates :shared_on, inclusion: { in: %w(Facebook Twitter Email) }, allow_blank: true

  scope :liked,    ->(page_id) { where(page: page_id, liked: true) }
  scope :disliked, ->(page_id) { where(page: page_id, liked: false) }

  delegate :slug, to: :page, prefix: true

  def self.to_csv(_ = {})
    csv_columns = ['page_slug', column_names].flatten

    CSV.generate do |csv|
      csv << csv_columns

      find_each do |page_feedback|
        csv << csv_columns.map { |column| page_feedback.send(column) }
      end
    end
  end
end
