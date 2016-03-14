class RevisionRegister
  attr_accessor :page, :user, :blocks_attributes

  def initialize(page, user: user, blocks_attributes: blocks_attributes)
    @page = page
    @user = user
    @blocks_attributes = blocks_attributes
  end

  def save!
    page.revisions.create!(data: revision_data)
  end

  def save_as_active_revision!
    new_revision = page.revisions.create!(data: revision_data)
    page.update_column(:active_revision_id, new_revision.id)
  end

  private

  def revision_data
    data = { user: user, blocks_attributes: blocks_attributes }

    if page.state_changed?
      data[:event]          = page.state
      data[:previous_event] = page.state_was
    end

    RevisionData.dump(data)
  end
end
