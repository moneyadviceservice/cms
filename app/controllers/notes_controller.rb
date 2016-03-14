class NotesController < Comfy::Admin::Cms::BaseController
  def create
    page  = @site.pages.find(params[:page_id])
    @note = page.revisions.new(data: revision_data)

    if params[:description].present? && @note.save
      @activity_log = ActivityLogPresenter.new(ActivityLog.parse(@note))
      render :create, status: :created
    else
      head :bad_request
    end
  end

  private

  def revision_data
    RevisionData.dump(user: current_user, note: params[:description])
  end
end
