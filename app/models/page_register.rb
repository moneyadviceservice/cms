class PageRegister
  attr_reader :page, :params, :current_user, :state_was
  delegate :new_record?, :persisted?, :save!, to: :page

  def initialize(page, params: params, current_user: current_user)
    @page                  = page
    @params                = params
    @current_user          = current_user
    @state_was             = page.state_was
    @blocks_attributes_was = page.blocks_attributes_was
  end

  def save
    update_state if new_record? && state_event == 'save_unsaved'

    if persisted? && state_event
      update_state
    else
      save!
    end

    create_revision
  end

  def create_revision
    return unless content_changed? && page.persisted?

    page.revisions.create!(data: revision_data)
  end

  def revision_data
    data = {}

    if state_changed?
      data[:previous_event] = @state_was
      data[:event]          = page.state
    end

    data[:blocks_attributes] = @blocks_attributes_was

    RevisionData.dump(data.merge(current_user: current_user))
  end

  def content_changed?
    (state_event.present? && state_changed?) || page.blocks_attributes_changed
  end

  def state_changed?
    @state_was != page.state
  end

  private

  def update_state
    @page.update_state!(state_event)
  end

  def state_event
    @state_event ||= params[:state_event]
  end
end
