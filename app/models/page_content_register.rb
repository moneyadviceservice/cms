class PageContentRegister
  attr_accessor :page, :author

  attr_writer :new_blocks_attributes

  def initialize(page, author:, new_blocks_attributes: nil)
    @page = page
    @author = author
    @new_blocks_attributes = new_blocks_attributes
  end

  # If passed in via params, attributes can be a hash rather than array,
  # so this is just a custom reader to handle that.
  def new_blocks_attributes
    blocks_attributes = if @new_blocks_attributes.is_a?(Hash)
      @new_blocks_attributes.values
    else
      @new_blocks_attributes
    end

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

    blocks_attributes
  end
end
