class PageFeedbackSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :liked, :session_id, :comment, :shared_on, :count

  def count
    {
      like:    PageFeedback.liked(page_id).count,
      dislike: PageFeedback.disliked(page_id).count
    }
  end
end
