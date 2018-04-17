class ComfortableMexicanSofa::Tag::SimpleComponent
  include ComfortableMexicanSofa::Tag

  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:page:(#{identifier}):?(?:simple_component)?\/(.*?)\s*}\}/m
  end

  def identifier
    "component_#{@identifier}"
  end
end
