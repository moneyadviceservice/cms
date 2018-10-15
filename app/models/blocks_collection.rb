class BlocksCollection
  include ActiveModel::Model
  attr_accessor :page, :non_collection_blocks, :new_blocks_attributes

  def update_collections
    assign_new_blocks

    blocks_to_be_deleted = @page.blocks.select do |block|
      deletable_blocks.detect do |d_block|
        block.identifier == d_block.keys.first &&
          block.content == d_block.values.first
      end
    end

    @page.blocks.delete(blocks_to_be_deleted)
  end

  def assign_new_blocks
    new_blocks.each do |block|
      @page.blocks.new(
        identifier: block.keys[0],
        content: block.values[0]
      )
    end
  end

  def new_blocks
    collection_blocks - current_collection_blocks
  end

  def deletable_blocks
    current_collection_blocks - collection_blocks
  end

  private

  def collection_blocks
    @collection_blocks ||= find_collections.map do |b|
      { b[:identifier] => b[:content] }
    end
  end

  def current_collection_blocks
    @current_collection_blocks ||= page.blocks.reject do |b|
      @non_collection_blocks.map { |b| b[:identifier] }.include?(b.identifier)
    end.map { |b| { b.identifier => b.content } }
  end

  def find_collections
    @new_blocks_attributes.select do |block|
      has_content = !block[:content].nil? && !block[:content].empty?
      block[:collection] && has_content
    end
  end
end
