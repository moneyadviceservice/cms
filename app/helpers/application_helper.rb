module ApplicationHelper
  include MainMenuHelper

  def item_taggable?(item)
    Tag.any? && item.respond_to?(:taggings)
  end
end
