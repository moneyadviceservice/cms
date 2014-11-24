class Presenter < SimpleDelegator

  def self.collect(collection)
    collection.collect { |object| new(object) }
  end

  def object
    __getobj__
  end
end
