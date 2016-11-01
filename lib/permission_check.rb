# Only editors are subject to restriction. They can:
# - save a new page to draft (create_initial_draft event)
# - update pages in draft state
# - create a new draft from a published page (create_new_draft event)
# - update pages in published_being_edited state
# - update pages in scheduled state that are not live yet (published_on is in the future)
class PermissionCheck

  attr_accessor :user, :page, :action, :event

  FORBIDDEN_ACTIONS = %w(destroy)
  ALLOWED_EDITOR_STATE_EVENTS = %w(create_initial_draft create_new_draft)
  ALLOWED_EDITOR_UPDATE_STATES = %w(draft published_being_edited scheduled)

  def initialize(user, page, action, event = nil)
    @user = user
    @page = page
    @action = action
    @event = event
  end

  def pass?
    if user.editor?
      # Everything is ok if:
      # - this is not a forbidden action (new, create and destroy)
      # - we are not updating
      #   - or if we are,
      #     - we are transitioning and the event is permitted
      #     - we are not transitioning (i.e. just saving the page) and the page is in a state where this is permitted
      !action_is_forbidden? && (!updating? || ((transitioning? && event_is_permitted?) || updating_is_permitted?))
    else
      true
    end
  end

  def fail?
    !pass?
  end

  private

  def transitioning?
    event.present?
  end

  def updating?
    action == 'update'
  end

  def page_scheduled?
    page.state == 'scheduled'
  end

  def scheduled_page_is_live?
    page.scheduled_on <= Time.current
  end

  def action_is_forbidden?
    FORBIDDEN_ACTIONS.include?(action)
  end

  def event_is_permitted?
    ALLOWED_EDITOR_STATE_EVENTS.include?(event)
  end

  def updating_is_permitted?
    ALLOWED_EDITOR_UPDATE_STATES.include?(page.state) && (!page_scheduled? || !scheduled_page_is_live?)
  end

end
