class LinkSerializer < ActiveModel::Serializer
  attributes :label, :url, :type
end
