class BlockComposer
  class Block < OpenStruct
    delegate :to_s, to: :content
  end

  attr_reader :blocks, :id, :parser

  def initialize(blocks = [], id = 'content', parser = Mastalk::Document)
    @blocks = Array(blocks)
    @parser = parser
    @id = id
  end

  def find(id)
    Block.new(blocks.find { |block| block['identifier'] == id })
  end

  def to_html
    parser.new(to_s).to_html
  end

  def to_s
    find(id).to_s
  end
end
