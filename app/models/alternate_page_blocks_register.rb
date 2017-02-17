# This class wraps logic for updating the "alternate" blocks of a page, used
# when there is a published article with an "alternate" version, i.e. a new
# version in draft or that has been scheduled to go live in the future.
#
# See the comments atop of PageBlocksRegister for a deeper explanation.
#
class AlternatePageBlocksRegister < PageContentRegister
  class Error < StandardError
  end

  def save!
    if page.published_being_edited?

      # If the page has just transitioned to published_being_edited we need to do some juggling of data.
      if page.state_changed?

        # The existing blocks which were live needs to be put into a revision and be set to the active revision
        RevisionRegister.new(page, user: author, blocks_attributes: page.blocks_attributes).save_as_active_revision!

        # And then we assign the new attributes to the blocks
        page.blocks_attributes = new_blocks_attributes

        # If it has just transitioned from scheduled, scheduled_on should now be emptied too
        page.scheduled_on = nil if page.state_was == 'scheduled'

        # And finally...
        page.save!

      # If it was already in a published_being_edited state, just update the blocks
      else
        update_blocks!
      end

    # If a page is scheduled and not yet live, then we just update the blocks.
    # It can only transition to this state from draft, which uses the blocks already,
    # so no juggling needed.
    elsif page.scheduled? && page.active_revision.present? && page.scheduled_on > Time.current
      update_blocks!

    # Anything else doesn't have alternate blocks
    else
      raise Error.new('Only pages in a state of published_being_edited, or scheduled with an active revision and with scheduled_on in the future can have alternate blocks')
    end
  end

  private

  # Create a revision with the existing blocks data and update the blocks with the new attributes
  def update_blocks!
    RevisionRegister.new(page, user: author, blocks_attributes: page.blocks_attributes).save!
    page.blocks_attributes = new_blocks_attributes
    page.save!
  end
end
