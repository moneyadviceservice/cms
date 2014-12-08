class LinkableObject
  include ActiveModel::Model

  attr_reader :object, :url

  def self.find(url)
    object = find_page(url) || find_file(url)

    new(object, url)
  end

  def self.find_page(url)
    paths = Comfy::Cms::Site.pluck(:path)
    slug  = url.gsub(/#{paths.join('|')}/, '').gsub(/\A\/\//, '')

    Comfy::Cms::Page.where(slug: slug).take
  end

  def self.find_file(url)
    file_name = File.basename(url)
    Comfy::Cms::File.find_by(file_file_name: file_name)
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
