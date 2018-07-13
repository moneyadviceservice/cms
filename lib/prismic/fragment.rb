module Prismic
  class Fragment
    attr_reader :field_type, :text, :format

    def initialize(fragment)
      @field_type = fragment['type']
      @text = fragment['content']['text'] if fragment['content']
      @format = fragment['content']['spans'] if fragment['content']
    end

    def document
      Nokogiri::HTML::DocumentFragment.parse(text)
    end
  end
end
