require_relative './hippo_file'

class HippoFileParser
  attr_reader :doc

  def self.parse(file)
    new(Nokogiri::XML(file)).all
  end

  def initialize(doc)
    @doc = doc
  end

  def all
    blobs = doc.xpath('//sv:property[@sv:type="Binary"][@sv:name="jcr:data"]')

    blobs.map { |blob| HippoFile.new(blob.parent) }
  end
end
