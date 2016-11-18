require_dependency ComfortableMexicanSofa::Engine.root.join('app', 'models', 'comfy', 'cms', 'category')

class Comfy::Cms::Category < ActiveRecord::Base
  has_many :links, as: :linkable
  accepts_nested_attributes_for :links, reject_if: ->(link) { link[:text].blank? },
                                        allow_destroy: true

  validates_presence_of :label, :title_en, :title_cy
  validates_uniqueness_of :label, :title_en, :title_cy, scope: :site_id

  belongs_to :small_image, class_name: 'Comfy::Cms::File'
  belongs_to :large_image, class_name: 'Comfy::Cms::File'

  has_many :category_promos

  has_many :clumpings, inverse_of: :category
  has_many :clumps, through: :clumpings

  accepts_nested_attributes_for :category_promos, reject_if: ->(promo) { promo[:title].blank? },
                                                  allow_destroy: true

  def self.navigation_categories
    where(parent_id: nil).reorder(:ordinal).partition(&:navigation?)
  end

  def child_categories
    self.class.where(parent_id: id).reorder(:ordinal)
  end

  def parents
    [find_parents].flatten.compact.reverse
  end

  def parent
    @parent ||= self.class.find_by(id: parent_id)
  end

  private

  def find_parents
    [parent] << parent.parents if parent.present?
  end
end
