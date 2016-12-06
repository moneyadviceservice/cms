# This class wraps logic for retrieving the "current" blocks of a page, taking into account
# situations where it might have an "alternate" version.
#
# See the comments atop of PageBlocksRegister for a deeper explanation.
#
class PageBlocksRetriever
  attr_accessor :page

  def initialize(page)
    @page = page
  end

  def live?
    # Of course, if a page is in published state, it's live
    if page.published?
      true

    # If it's in published_being_edited state, there should be an active_revision
    elsif page.published_being_edited?
      true

    # If it's scheduled....
    elsif page.scheduled?

      # If the scheduled time is in the past, then it's live
      if page.scheduled_on <= Time.current
        true

      # If not, it's not live, but if there's an active revision then this it's
      # a new version of a published page which is.
      elsif page.active_revision.present?
        true
      end
    end
  end

  def blocks_attributes
    # If page is in published_being_edited, the "current" version of the
    # blocks will be the active_revision.
    if page.published_being_edited?
      return_active_revision_blocks_attributes

    # If a page is scheduled....
    elsif page.scheduled?

      # ... but not live yet...
      if page.scheduled_on > Time.current

        # ... we look for an active revision. If one exists,
        # this a published article with a scheduled update.
        # The current blocks are in the active revision.
        if page.active_revision.present?
          return_active_revision_blocks_attributes

        # If there is no active_revision, then this is a plain scheduled post
        # that has not gone live yet, so the blocks are in the block.
        else
          return_page_blocks_attributes
        end

      # If the scheduled post is live, the current blocks are coming
      # from the main blocks, so again we return them.
      else
        return_page_blocks_attributes
      end

    # Any state other than published_being_edited or scheduled
    # just uses the main blocks
    else
      return_page_blocks_attributes
    end
  end

  def block_content(identifier)
    block = blocks_attributes.find { |block_attributes| block_attributes[:identifier] == identifier.to_s }

    block[:processed_content] || block[:content]
  end

  private

  def return_page_blocks_attributes
    page.blocks.collect { |block| { identifier: block.identifier, content: block.content }.with_indifferent_access }
  end

  def return_active_revision_blocks_attributes
    page.active_revision.data[:blocks_attributes]
  end
end
