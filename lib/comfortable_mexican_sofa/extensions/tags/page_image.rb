class ComfortableMexicanSofa::Tag::PageImage
  include ComfortableMexicanSofa::Tag

  def self.regex_tag_signature(identifier = nil)
    identifier ||= IDENTIFIER_REGEX
    /\{\{\s*cms:page:(#{identifier}):?(?:image)?\s*\}\}/
  end

  delegate :content, to: :block
end
