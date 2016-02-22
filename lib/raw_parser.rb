class RawParser
  attr_reader :content

  def initialize(content)
    @content = content
  end

  def to_html
    content.to_s
  end
end
