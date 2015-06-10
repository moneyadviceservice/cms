class DbLinkSerializer < ActiveModel::Serializer
  attributes :text, :url, :locale
end
