class LinkableObject
  include ActiveModel::Model

  attr_reader :object, :url

  def self.find(url)
    object = find_page(url) || find_file(url)

    new(object, url)
  end

  def self.find_page(url)
    Comfy::Cms::Page.where('slug = :slug OR full_path = :full_path', slug: url, full_path: url).take
  end

  def self.find_file(url)
    Comfy::Cms::File.find_by(file_file_name: url)
  end

  def initialize(object, url)
    @object = object
    @url    = url
  end

  def label
    object.try(:label) || url
  end

  def type
    return 'external' if object.blank?

    object.class.model_name.element
  end

  def read_attribute_for_serialization(value)
    send(value)
  end
end
