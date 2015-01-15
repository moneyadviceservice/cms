require ComfortableMexicanSofa::Engine.root.join('app', 'models', 'comfy', 'cms', 'category')

class Comfy::Cms::Category < ActiveRecord::Base
  def parents
    [find_parents].flatten.compact.reverse
  end

  def find_parents
    [parent] << parent.parents if parent.present?
  end

  def parent
    @parent ||= self.class.where(id: parent_id).first
  end
end
