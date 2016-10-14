class PageFeedbackSerializer < ActiveModel::Serializer
  attributes :page_id, :liked, :session_id
end
