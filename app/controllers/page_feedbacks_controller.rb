class PageFeedbacksController < Comfy::Admin::Cms::BaseController
  respond_to :html, :csv

  def index
    @page_feedbacks = PageFeedback.includes(:page).page(params[:page])
    respond_with(@page_feedbacks)
  end
end
