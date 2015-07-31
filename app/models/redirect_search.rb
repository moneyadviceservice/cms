class RedirectSearch
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :query
end
