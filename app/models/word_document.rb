class WordDocument
  attr_reader :file, :parser

  delegate :path, to: :file

  def initialize(file, parser = WordToMarkdown)
    @file = file
    @parser = parser
  end

  def to_s
    @_converted ||= parser.new(path, display: ':99', format: 'html:"HTML (StarWriter)"').to_s
  end
end
