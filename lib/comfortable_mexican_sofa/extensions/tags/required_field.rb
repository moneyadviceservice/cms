class ComfortableMexicanSofa::Tag::RequiredField
  include ComfortableMexicanSofa::Tag

  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:field:(#{identifier})?(.*):required\s*\}\}/
  end
end
