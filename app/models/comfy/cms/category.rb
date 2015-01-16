require ComfortableMexicanSofa::Engine.root.join('app', 'models', 'comfy', 'cms', 'category')

class Comfy::Cms::Category < ActiveRecord::Base
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
