class LinkableObject
  include ActiveModel::Model

  attr_reader :url, :link_type

  validates :link_type, inclusion: { in: %w(file page) }

  def self.find(url, link_type:)
    linkable_object = LinkableObject.new(url, link_type: link_type)

    send("find_#{link_type.underscore}", url) if linkable_object.valid?
  end

  def self.find_page(url)
    Comfy::Cms::Page.find_by(slug: url)
  end

  def self.find_file(url)
    Comfy::Cms::File.find_by(file_file_name: url)
  end

  def initialize(url, link_type:)
    @url       = url
    @link_type = link_type
  end
end