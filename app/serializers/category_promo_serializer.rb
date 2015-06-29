class CategoryPromoSerializer < ActiveModel::Serializer
  attributes :promo_type, :title, :description, :locale, :url
end
