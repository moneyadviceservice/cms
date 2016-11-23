class PageFeedbacksController < Comfy::Admin::Cms::BaseController
  def index
    @page_feedbacks = PageFeedback.includes(:page).page(params[:page]).order('created_at DESC')
  end
end
