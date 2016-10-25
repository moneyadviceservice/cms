class PageFeedbacksController < Comfy::Admin::Cms::BaseController
  def index
    @page_feedbacks = PageFeedback.includes(:page).page(params[:page])
  end
end
