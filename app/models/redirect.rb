class Redirect < ActiveRecord::Base
  REDIRECT_TYPES = %w{ temporary permanent }

  has_paper_trail class_name: 'RedirectVersion'

  before_validation :remove_source_trailing_slashes
  before_validation :remove_destination_trailing_slashes

  validates :source, presence: true, uniqueness: true, format: { with: /\A\// }
  validates :destination, presence: true, format: { with: /\A\/en|\/cy/ }
  validates :redirect_type, presence: true, inclusion: { in: REDIRECT_TYPES }
  validate  :validate_different_source_and_destination
  validate  :destination_does_not_match_existing_source
  validate  :source_does_not_match_existing_destination

  scope :recently_updated_order, -> { order(updated_at: :desc) }

  scope :search, ->(query) { where('source LIKE ? OR destination LIKE ?', "%#{query}%", "%#{query}%") }

  def status_code
    {
      'permanent' => 301,
      'temporary' => 302
    }[redirect_type]
  end

  private

  def validate_different_source_and_destination
    if source == destination
      errors.add(:destination, :identical_to_source)
    end
  end

  def remove_source_trailing_slashes
    self.source = source.gsub(/\/*\z/, '') if source.present?
  end

  def remove_destination_trailing_slashes
    self.destination = destination.gsub(/\/*\z/, '') if destination.present?
  end

  def destination_does_not_match_existing_source
    if Redirect.exists?(source: destination)
      errors.add(:destination, :matches_an_existing_source)
    end
  end

  def source_does_not_match_existing_destination
    if Redirect.exists?(destination: source)
      errors.add(:source, :matches_an_existing_destination)
    end
  end
end
