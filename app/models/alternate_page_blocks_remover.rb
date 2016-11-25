# This class wraps logic for removing the "alternate" blocks of a page, used
# when there is a published article with an "alternate" version, i.e. a new
# version in draft or that has been scheduled to go live in the future.
#
# See the comments atop of PageBlocksRegister for a deeper explanation.
#
class AlternatePageBlocksRemover
  class Error < StandardError
  end

  attr_accessor :page, :remover

  attr_writer :new_blocks_attributes

  def initialize(page, remover:)
    @page = page
    @remover = remover
  end

  def remove!
    # You can remove a draft new version of a published article
    if page.published_being_edited?
      # copy the blocks' attributes from the active revision
      # to the actual blocks and publish that content.
      page.publish
      PageBlocksRegister.new(page, author: remover, new_blocks_attributes: page.active_revision.data[:blocks_attributes]).save!

    # Anything else can't be removed. Scheduled articles must be unscheduled (returned to draft) to be removed.
    else
      raise Error.new('Only pages in a state of published_being_edited have alternate content that can be removed')
    end
  end
end
