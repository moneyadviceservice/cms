class NotesController < Comfy::Admin::Cms::BaseController
  def create
    @page  = @site.pages.find(params[:page_id])

    if params[:description].present?
      @note         = @page.revisions.create!(data: revision_data)
      @activity_log = ActivityLogPresenter.new(ActivityLog.parse(@note))
      render :create, status: :created
    else
      head :bad_request
    end
  end

  private

  def revision_data
    {
      note: params[:description],
      author: {
        id:   current_user.id,
        name: current_user.name
      }
    }
  end
end
