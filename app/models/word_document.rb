class WordDocument
  attr_reader :file, :parser

  def initialize(file, parser=WordToMarkdown)
    @file = file
    @parser = parser
  end

  def path
    file.path
  end

  def to_s
    @_converted ||= parser.new(path, display: ':99').to_s
  end
end