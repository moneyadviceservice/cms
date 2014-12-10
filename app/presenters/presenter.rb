class Presenter < SimpleDelegator
  delegate :url_helpers, to: 'Rails.application.routes'

  def self.collect(collection)
    collection.collect { |object| new(object) }
  end

  def object
    __getobj__
  end
end
