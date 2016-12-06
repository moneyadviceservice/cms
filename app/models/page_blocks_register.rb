# coding: utf-8
# This class wraps logic for updating the "current" blocks_attributes of a page, taking into account
# situations where it might have an "alternate" version.
#
# Single version articles:
# - an unsaved, draft or published article
# - a scheduled article that's not live yet
# - a scheduled article that's gone live
# - a published article with a scheduled update that's now gone live
#
# Dual version articles:
# - a published article with a draft one being edited (published_being_edited state)
#  - the published article is the current article
# - a published article with a scheduled update that's not gone live yet
#  - the published article is the current article
#
# Precautions should be taken in the controller to handle situations where an article
# transitions between one and two version states during editing (as it's time related).
#
# E.g. you start by editing the live version of a published article with a scheduled update.
#      During the process the time for the update to go live passes by and when you hit submit
#      the article has gone back to having only a single version, the live update.
#
class PageBlocksRegister
  attr_accessor :page, :author

  attr_writer :new_blocks_attributes

  def initialize(page, author:, new_blocks_attributes: nil)
    @page = page
    @author = author
    @new_blocks_attributes = new_blocks_attributes
  end

  # If passed in via params, attributes can be a hash rather than array,
  # so this is just a custom reader to handle that.
  def new_blocks_attributes
    blocks_attributes = if @new_blocks_attributes.is_a?(Hash)
      @new_blocks_attributes.values
    else
      @new_blocks_attributes
    end

    processed_content = ContentComposer.new(
      @page.site.locale,
      blocks_attributes.first['content']
    ).to_html

    blocks_attributes.first.merge(
      processed_content: processed_content
    )

    blocks_attributes
  end

  def save!
    # If a page is has not been saved before, we always want to put the
    # new data straight into the first blocks.
    if page.new_record?
      create_initial_blocks!

    # If we've just transitioned from published_being_edited, or scheduled
    # we might have an active revision which is now not needed.
    elsif page.published?
      update_blocks!
      page.update_attribute(:active_revision, nil)

    # If page is in published_being_edited, the "current" blocks will be
    # in an active_revision, so create a new one of those.
    elsif page.published_being_edited?
      create_active_revision!

    # If a page is scheduled....
    elsif page.scheduled?

      # ... but not live yet...
      if page.scheduled_on > Time.current

        # ... we look for an active revision. If one exists,
        # this a published article with a scheduled update.
        # To update the current version, we create a new active revision.
        if page.active_revision.present?
          create_active_revision!

        # If there is no active_revision, then this is a plain scheduled post
        # that has not gone live yet, so we just update the blocks.
        else
          update_blocks!
        end

      # ... and is live...
      else

        # ... then the blocks_attributes is coming from the block, so we update that.
        # The active_revision doesn't come into it.
        update_blocks!
      end

    # Any state other than published_being_edited or scheduled just
    # needs to be updated in the block.
    else
      update_blocks!
    end
  end

  private

  # Populate the blocks_attributes for the first time to create the initial block
  def create_initial_blocks!
    page.blocks_attributes = new_blocks_attributes
    page.save!
  end

  # Create a revision with the existing blocks data and update the blocks with the new attributes
  def update_blocks!
    RevisionRegister.new(page, user: author, blocks_attributes: page.blocks_attributes).save!
    page.blocks_attributes = new_blocks_attributes
    page.save!
  end

  # Create a new revision with the new blocks_attributes and set it as the active revision
  def create_active_revision!
    RevisionRegister.new(page, user: author, blocks_attributes: new_blocks_attributes).save_as_active_revision!
  end
end
