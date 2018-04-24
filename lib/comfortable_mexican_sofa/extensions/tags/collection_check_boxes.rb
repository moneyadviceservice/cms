class ComfortableMexicanSofa::Tag::CollectionCheckBoxes
  include ComfortableMexicanSofa::Tag
  attr_accessor :element

  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:page:(#{identifier}):?(?:collection_check_boxes)?\/(.*?)\s*}\}/m
  end

  def collection_params
    self.params.first.split(', ')
  end
end
