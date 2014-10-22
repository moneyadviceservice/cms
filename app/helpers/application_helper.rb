module ApplicationHelper
  include MainMenuHelper

  def item_taggable?(item)
    Tag.any? and item.respond_to?(:taggings)
  end
end
