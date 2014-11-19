class PageRegister
  attr_reader :params, :state_was, :current_user

  def initialize(page, params: params, current_user: current_user)
    @page         = page
    @params       = params
    @current_user = current_user
    @state_was    = page.state_was
  end

  def save
    update_state if @page.new_record? && state_event == 'save_unsaved'

    if @page.persisted? && state_event
      update_state
    else
      @page.save!
    end

    create_revision
  end

  def create_revision
    return if state_event.blank? || state_was == @page.state

    @page.revisions.create!(
      data: {
        author: {
          id:   current_user.id,
          name: current_user.name
        },
        event: {
          from: state_was,
          to:   @page.state
        }
      }
    )
  end

  private

  def update_state
    @page.update_state!(state_event)
  end

  def state_event
    @state_event ||= params[:state_event]
  end
end
