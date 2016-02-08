class WordDocument
  attr_reader :file, :parser

  delegate :path, to: :file

  class Pandoc
    attr_reader :path

    def initialize(path)
      @path = path
    end

    # TODO WARNING open to injection
    def to_markdown
      `pandoc -S --no-wrap --to=markdown_github --from=docx --atx-headers #{path}`.gsub('’', '\'').gsub('“', '"').gsub('”', '"').gsub('‘', '\'')
    end
  end

  def initialize(file, parser = Pandoc)
    @file = file
    @parser = parser
  end

  def to_markdown
    @_converted ||= parser.new(path).to_markdown
  end
end
