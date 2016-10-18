class ContentComposer
  attr_reader :content, :parser

  def initialize(content, parser = Mastalk::Document)
    @content = content
    @parser = parser
  end

  def to_html
    html = parser.new(to_s).to_html

    post_processors.inject(html) do |result, processor|
      processor.new(result).call
    end
  end

  def to_s
    content.to_s
  end

  def post_processors
    [TableWrapper, ExternalLink]
  end
end
