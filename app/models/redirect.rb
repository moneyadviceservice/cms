class Redirect < ActiveRecord::Base
  REDIRECT_TYPES = %w{ temporary permanent }

  has_paper_trail class_name: 'RedirectVersion'

  validates :source, presence: true, uniqueness: true
  validates :destination, presence: true, format: { with: /\A\/en|\/cy/ }
  validates :redirect_type, presence: true, inclusion: { in: REDIRECT_TYPES }
  validate  :validate_different_source_and_destination

  scope :recently_updated_order, -> { order(updated_at: :desc) }

  scope :search, ->(query) { where('source LIKE ? OR destination LIKE ?', "%#{query}%", "%#{query}%") }

  private

  def validate_different_source_and_destination
    if source == destination
      errors.add(:destination, :identical_to_source)
    end
  end
end
