class PageFeedbackSerializer < ActiveModel::Serializer
  attributes :id, :page_id, :liked, :session_id, :comment, :shared_on
end
