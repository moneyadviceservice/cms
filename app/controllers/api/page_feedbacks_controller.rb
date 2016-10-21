class API::PageFeedbacksController < APIController
  before_action :find_site, :find_page

  def create
    page_feedback = PageFeedback.new(page_feedback_params)

    if page_feedback.save
      render json: page_feedback, status: 201, serializer: PageFeedbackSerializer
    else
      render json: { errors: page_feedback.errors.full_messages }, status: 422
    end
  end

  private

  def find_page
    @page = @current_site.pages.find_by(slug: params[:slug])

    render json: { message: %(Page "#{params[:slug]}" not found) },
           status: 404 if @page.blank?
  end

  def page_feedback_params
    params.permit(:liked, :session_id).merge(page_id: @page.id)
  end
end
