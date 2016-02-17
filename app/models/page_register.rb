class PageRegister
  attr_reader :page, :params, :current_user, :state_was
  delegate :new_record?, :persisted?, :save!, to: :page

  ALLOWED_EDITOR_STATE_EVENTS = %w(create_initial_draft create_new_draft)

  def initialize(page, params: params, current_user: current_user)
    @page                  = page
    @params                = params
    @current_user          = current_user
    @state_was             = page.state_was
    @blocks_attributes_was = page.blocks_attributes_was
  end

  def save
    ensure_permission_to_save!

    update_state_if_new_page
    update_state_or_save_existing_page
    create_revision
    send_change_notfication
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

  def send_change_notfication
    return unless @current_user.editor?
    RevisionMailer.external_editor_change(user: @current_user, page: @page)
                  .deliver
  end

  def update_state
    @page.update_state!(state_event)
  end

  def state_event
    @state_event ||= params[:state_event]
  end

  def page_changes_not_permitted
    @page.errors.add(:base, 'Insufficient permissions to change')
    ActiveRecord::RecordInvalid.new(@page)
  end

  def ensure_permission_to_save!
    return unless @current_user.editor?
    fail page_changes_not_permitted if new_record?
    fail page_changes_not_permitted unless editor_can_perform_event?
  end

  def editor_can_perform_event?
    ALLOWED_EDITOR_STATE_EVENTS.include? state_event
  end

  def update_state_if_new_page
    update_state if new_record? && state_event == 'create_initial_draft'
  end

  def update_state_or_save_existing_page
    if persisted? && state_event
      update_state
    else
      save!
    end
  end
end
