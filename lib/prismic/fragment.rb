module Prismic
  class Fragment
    attr_reader :original_fragment, :field_type, :text, :text_format

    def initialize(fragment)
      @original_fragment = fragment
      @field_type = fragment['type']
      @text = fragment['content']['text'] if fragment['content']
      @text_format = fragment['content']['spans'] if fragment['content']
    end
  end
end
