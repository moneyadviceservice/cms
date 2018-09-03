class BlocksRetriever
  attr_reader :block, :scope

  def initialize(block, scope)
    @block = block
    @scope = scope
  end

  # If we're previewing, we want to recognise when a live article
  # has a draft new version in progress.
  #
  def retrieve
    if scope == 'preview'
      if alternate_blocks_retriever.blocks_attributes.present?
        alternate_blocks_retriever.block(identifier)
      else
        blocks_retriever.block(identifier)
      end
    elsif blocks_retriever.live?
      blocks_retriever.block(identifier)
    end
  end

  def blocks_retriever
    @blocks_retriever ||= PageBlocksRetriever.new(page)
  end

  def alternate_blocks_retriever
    @alternate_blocks_retriever ||= AlternatePageBlocksRetriever.new(page)
  end

  def page
    block.blockable
  end

  def identifier
    block.identifier
  end
end
