class CategoryLinkSerializer < ActiveModel::Serializer
  attributes :text, :url, :locale
end
