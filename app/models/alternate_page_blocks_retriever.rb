# This class wraps logic for retrieving the "alternate" blocks of a page, used
# when there is a published article with an "alternate" version, i.e. a new
# version in draft or that has been scheduled to go live in the future.
#
# See the comments atop of PageBlocksRegister for a deeper explanation.
#
class AlternatePageBlocksRetriever
  attr_accessor :page

  def initialize(page)
    @page = page
  end

  def blocks_attributes
    # If a page is in published_being_edited state, it always
    # has secondary blocks (the draft)
    if page.published_being_edited?
      page.blocks_attributes

    # If it's scheduled and not yet live, that can be a scheduled update
    # to a live article, which is in the active_revision
    elsif page.scheduled? && page.scheduled_on > Time.current && page.active_revision.present?
      page.blocks_attributes

      # Any other states only have primary blocks
    end
  end

  def block(identifier)
    blocks_attributes.find do |block_attributes|
      block_attributes[:identifier] == identifier.to_s
    end
  end
end
