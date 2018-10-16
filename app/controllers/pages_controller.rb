class PagesController < Comfy::Admin::Cms::PagesController
  helper 'page_blocks'

  before_action :check_permissions
  before_action :check_alternate_available, only: [:edit, :update, :destroy]
  before_action :check_can_destroy, only: :destroy

  def index
    @all_pages = Comfy::Cms::Page.includes(:layout, :site, :categories)
    @pages_by_parent = pages_grouped_by_parent
    @pages = apply_filters
  end

  def new
    @blocks_attributes = @page.blocks_attributes
  end

  def create
    save_page
    flash[:success] = I18n.t('comfy.admin.cms.pages.created')
    redirect_to action: :edit, id: @page
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = I18n.t('comfy.admin.cms.pages.creation_failure')
    render action: :new
  end

  def edit
    @blocks_attributes = if params[:alternate]
                           AlternatePageBlocksRetriever.new(@page).blocks_attributes
                         else
                           PageBlocksRetriever.new(@page).blocks_attributes
                         end
  end

  def update
    save_page
    flash[:success] = I18n.t('comfy.admin.cms.pages.updated')

    if current_user.editor?
      RevisionMailer.external_editor_change(user: current_user, page: @page).deliver_now
    end

    if updating_alternate_content?
      redirect_to action: :edit, id: @page, alternate: true
    else
      redirect_to action: :edit, id: @page
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = I18n.t('comfy.admin.cms.pages.update_failure')
    render action: :edit
  end

  def destroy
    if params[:alternate].nil?
      @page.destroy
      flash[:success] = "Draft #{@page.layout.label.downcase} deleted"
    else
      AlternatePageBlocksRemover.new(@page, remover: current_user).remove!
      flash[:success] = "Draft update for #{@page.layout.label.downcase} removed"
    end
    redirect_to :action => :index
  end

  protected

  def presenter
    @presenter ||= PagePresenter.new(@page)
  end
  helper_method :presenter

  def save_page
    # First change state if needed. We do a non saving event so we can access
    # the dirty logging in the content registers.
    @page.update_state(params[:state_event]) if params[:state_event]
    blocks_attributes = params[:blocks_attributes]

    # We need to look at the current state of the page to know if we're updating
    # current or alternate content. This may have changed due to the state event.
    if updating_alternate_content?
      AlternatePageBlocksRegister.new(
        @page,
        author: current_user,
        new_blocks_attributes: blocks_attributes
      ).save!
    else
      PageBlocksRegister.new(
        @page,
        author: current_user,
        new_blocks_attributes: blocks_attributes
      ).save!
    end

    # Now save any changes to the page on attributes other than content (assignment has been
    # performed in a filter, defined in the comfy gem). We do this after updating the content
    # as that has logic dependent on the schedule time, which should only be changed afterwards.
    @page.save!
    @page.mirror_categories!
    @page.mirror_suppress_from_links_recirculation!
  end

  def apply_filters
    @pages = @all_pages.filter(params.slice(:category, :layout, :last_edit, :status, :language))

    if params[:search].present?
      Comfy::Cms::Search.new(@pages, params[:search]).results
    else
      @last_published_pages = @all_pages.published.reorder(updated_at: :desc).limit(4)
      @last_draft_pages = @all_pages.draft.reorder(updated_at: :desc).limit(4)
      @pages.reorder(updated_at: :desc).page(params[:page])
    end
  end

  def check_permissions
    if PermissionCheck.new(current_user, @page, action_name, params[:state_event]).fail?
      flash[:danger] = 'Insufficient permissions to change'
      redirect_to comfy_admin_cms_site_pages_path(params[:site_id])
    end
  end

  def check_alternate_available
    if params[:alternate] && !AlternatePageBlocksRetriever.new(@page).blocks_attributes.present?
      flash[:danger] = 'Alternate content is not currently available for this page'
      redirect_to action: :edit, id: @page
    end
  end

  def check_can_destroy
    unless @page.draft? || @page.published_being_edited? || (@page.scheduled? && @page.active_revision.present? && @page.scheduled_on > Time.current)
      flash[:danger] = 'You cannot delete a page in this state'
      redirect_to action: :edit, id: @page
    end
  end

  def updating_alternate_content?
    if @page.published_being_edited?
      params[:alternate].present? || params[:state_event] == 'create_new_draft'
    elsif @page.scheduled?
      @page.active_revision.present? && (params[:alternate].present? || params[:state_event] == 'scheduled')
    else
      false
    end
  end
end
