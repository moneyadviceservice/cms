class PageContentRegister
  attr_accessor :page, :author

  attr_reader :home_page_tile_identifer
  attr_writer :new_blocks_attributes

  def initialize(page, author:, new_blocks_attributes: nil)
    @page = page
    @author = author
    @new_blocks_attributes = new_blocks_attributes
    @home_page_tile_identifer = /raw_tile_\d_image/
  end

  # If passed in via params, attributes can be a hash rather than array,
  # so this is just a custom reader to handle that.
  def new_blocks_attributes
    return [] if @new_blocks_attributes.empty?
    blocks_attributes = if @new_blocks_attributes.is_a?(Hash)
                          @new_blocks_attributes.values
                        else
                          @new_blocks_attributes
                        end

    if home_page? || footer?
      return blocks_attributes + include_srcset_block(blk_attrs: blocks_attributes)
    end

    convert_content_to_html(blocks_attributes)

    blocks_attributes
  end

  # Create a revision with the existing blocks data and update the blocks with the new attributes
  def update_blocks!
    RevisionRegister.new(page, user: author, blocks_attributes: page.blocks_attributes).save!

    assign_blocks
    page.save!
  end

  def assign_blocks
    non_collection_blocks = new_blocks_attributes.reject do |block|
      block[:collection]
    end
    page.blocks_attributes = non_collection_blocks

    BlocksCollection.new(
      page: page,
      non_collection_blocks: non_collection_blocks,
      new_blocks_attributes: new_blocks_attributes
    ).update_collections
  end

  private

  def include_srcset_block(blk_attrs: [])
    blk_attrs
      .select { |b| b[:identifier] =~ home_page_tile_identifer }
      .map do |b|
      {
        identifier: b[:identifier].sub('image', 'srcset'),
        content: srcset_content(original_url: b[:content]).join(', ')
      }
    end
  end

  def srcset_content(original_url:)
    Comfy::Cms::File.available_styles.map do |h|
      "#{original_url.sub('original', h[:style].to_s)} #{h[:width]}w"
    end
  end

  def home_page?
    layout_identifier == 'home_page'
  end

  def footer?
    layout_identifier == 'footer'
  end

  def layout_identifier
    @page.layout.try(:identifier)
  end

  def convert_content_to_html(blocks_attributes)
    markdown_content = ActiveSupport::HashWithIndifferentAccess.new(
      blocks_attributes.first
    )[:content]

    processed_content = ContentComposer.new(
      @page.site.locale,
      markdown_content
    ).to_html

    blocks_attributes.first.merge!(
      processed_content: processed_content
    )
  end
end
