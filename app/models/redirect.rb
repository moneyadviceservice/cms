class Redirect < ActiveRecord::Base
  REDIRECT_TYPES = %w[permanent temporary].freeze

  default_scope { where(active: true) }

  has_paper_trail class_name: 'RedirectVersion'

  before_validation :remove_source_trailing_slashes
  before_validation :remove_destination_trailing_hashes
  before_validation :remove_destination_trailing_slashes

  validates :source, presence: true, format: { with: /\A\// }
  validates :source, uniqueness: { scope: :active }, if: :active?
  validates :source, format: { without: /\#/ }
  validates :source, format: { without: /\.\z/ }
  validate :source_allows_certain_extensions

  validates :destination, presence: true, format: { with: /\A\/en|\/cy/ }
  validates :redirect_type, presence: true, inclusion: { in: REDIRECT_TYPES }
  validate :validate_different_source_and_destination
  validate :destination_does_not_match_existing_source
  validate :source_does_not_match_existing_destination

  scope :recently_updated_order, -> { order(updated_at: :desc) }

  scope :search, ->(query) { where('source LIKE ? OR destination LIKE ?', "%#{query}%", "%#{query}%") }

  def status_code
    {
      'permanent' => 301,
      'temporary' => 302
    }[redirect_type]
  end

  def inactivate!
    update(active: false)
  end

  private

  def source_allows_certain_extensions
    return if source.blank?
    return if source =~ /(\.html|\.pdf|\.aspx)\z/
    return unless source =~ /(\..*)\z/

    errors.add(:source, :invalid_extension)
  end

  def validate_different_source_and_destination
    return unless source == destination

    errors.add(:destination, :identical_to_source)
  end

  def remove_destination_trailing_hashes
    self.destination = destination.gsub(/#*\z/, '') if destination.present?
  end

  def remove_source_trailing_slashes
    self.source = source.gsub(/\/*\z/, '') if source.present?
  end

  def remove_destination_trailing_slashes
    self.destination = destination.gsub(/\/*\z/, '') if destination.present?
  end

  def destination_does_not_match_existing_source
    return if destination.blank?
    return unless Redirect.where.not(id: id).exists?(source: destination.split('?').first)

    errors.add(:destination, :matches_an_existing_source)
  end

  def source_does_not_match_existing_destination
    return unless Redirect.where.not(id: id).exists?(['destination = ? OR destination LIKE ?', source, "#{source}?%"])

    errors.add(:source, :matches_an_existing_destination)
  end
end
