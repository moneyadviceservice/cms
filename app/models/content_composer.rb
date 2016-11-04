class ContentComposer
  attr_reader :locale, :content, :parser

  def initialize(locale, content, parser = Mastalk::Document)
    @locale  = locale
    @content = content
    @parser  = parser
  end

  def to_html
    html = parser.new(to_s).to_html

    post_processors.inject(html) do |result, processor|
      processor.new(locale, result).call
    end
  end

  def to_s
    content.to_s
  end

  def post_processors
    [TableWrapper, TableCaptioner, ExternalLink]
  end
end
