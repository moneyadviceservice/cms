class API::PageFeedbacksController < APIController
  before_action :find_site, :find_page
  before_action :find_page_feedback, only: :update
  before_action API::AuthenticationFilter

  def create
    page_feedback = @page.feedbacks.new(page_feedback_params)

    if page_feedback.save
      render json: page_feedback, status: 201, serializer: PageFeedbackSerializer
    else
      render json: { errors: page_feedback.errors.full_messages }, status: 422
    end
  end

  def update
    if @page_feedback.update(params.permit(:comment, :shared_on))
      render json: @page_feedback, status: 200
    else
      render json: { message: @page_feedback.errors.full_messages }, status: 422
    end
  end

  private

  def find_page
    @page = @current_site.pages.find_by(slug: params[:slug])

    render json: { message: %(Page "#{params[:slug]}" not found) },
           status: 404 if @page.blank?
  end

  def page_feedback_params
    params.permit(:liked, :session_id)
  end

  def find_page_feedback
    @page_feedback = @page.feedbacks.where(session_id: params[:session_id]).last

    render json: { message: %(Page feedback "#{@page.slug}" not found) },
           status: 404 if @page_feedback.blank?
  end
end
