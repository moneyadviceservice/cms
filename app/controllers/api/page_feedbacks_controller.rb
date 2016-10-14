class API::PageFeedbacksController < APIController
  def create
    page_feedback = PageFeedback.new(page_feedback_params)

    if page_feedback.save
      render json: {}, status: 201
    else
      render json: {}, status: 422
    end
  end

  private
  def page_feedback_params
    params.permit(:page_id, :liked, :session_id)
  end
end
