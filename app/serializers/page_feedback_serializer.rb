class PageFeedbackSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :liked, :session_id, :comment, :shared_on,
             :likes_count, :dislikes_count

  def likes_count
    PageFeedback.liked(page_id).count
  end

  def dislikes_count
    PageFeedback.disliked(page_id).count
  end
end
