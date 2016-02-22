class RevisionRegister
  attr_accessor :page, :user

  def initialize(page, user: user)
    @page = page
    @user = user
  end

  def save!
    page.revisions.create!(data: revision_data)
  end

  private

  def revision_data
    data = { user: user }

    # Note that we're using #previous_changes because the page has been saved
    # at this point and the dirty tracking data has been reset.
    if page.previous_changes[:state].present?
      data[:event]          = page.state
      data[:previous_event] = page.previous_changes[:state].first
    end

    # However here, while it looks like we're somehow using dirty tracking to see the changes,
    # it's because this is not real dirty tracking. It's DIY dirty tracking defined in
    # ComfortableMexicanSofa::CmsManageable, which doesn't clear after save.
    data[:blocks_attributes] = page.blocks_attributes_was

    RevisionData.dump(data)
  end
end
