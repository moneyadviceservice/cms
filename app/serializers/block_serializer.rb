require 'active_model_serializers'

class BlockSerializer < ActiveModel::Serializer
  attributes :identifier, :content, :created_at, :updated_at

  private

  def content
    if identifier.start_with?('raw_')
      ContentComposer.new(block_content, RawParser).to_html
    else
      if block_content
        ContentComposer.new(block_content).to_html
      end
    end
  end

  private

  def page
    object.blockable
  end

  def block_content
    if identifier.start_with?('raw_')
      object.content
    else
      # If we're previewing, we want to recognise when a live article
      # has a draft new version in progress.
      if scope == 'preview'
        if alternate_blocks_retriever.blocks_attributes.present?
          alternate_blocks_retriever.block_content(:content)
        else
          blocks_retriever.block_content(:content)
        end

      else
        blocks_retriever.block_content(:content) if blocks_retriever.live?
      end
    end
  end

  def blocks_retriever
    @blocks_retriever ||= PageBlocksRetriever.new(page)
  end

  def alternate_blocks_retriever
    @alternate_blocks_retriever ||= AlternatePageBlocksRetriever.new(page)
  end

end
