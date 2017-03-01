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
    blocks_attributes = if @new_blocks_attributes.is_a?(Hash)
                          @new_blocks_attributes.values
                        else
                          @new_blocks_attributes
                        end

    if home_page? || footer?
      return blocks_attributes + srcset_blocks(blk_attrs: blocks_attributes)
    end

    convert_content_to_html(blocks_attributes)

    blocks_attributes
  end

  private

  def srcset_blocks(blk_attrs: [])
    blk_attrs
      .select { |b| b[:identifier] =~ home_page_tile_identifer }
      .map do |b|
      {
        identifier: b[:identifier].sub('image', 'srcset'),
        content: srcset_content(original_url: b[:content]).join(', ')
      }
    end
  end

  def available_styles
    Comfy::Cms::File.new.file.styles
      .reject { |k,_| [:cms_thumb, :cms_medium].include? k }
      .map do |style, object|
      {
        style: style,
        width: object.geometry.split('x').first
      }
    end
  end

  def srcset_content(original_url:)
    available_styles.map do |h|
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
