module NewBlocksAttributes
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

  def srcset_blocks(input_args: [])
    input_args.select { |b| b[:identifier] =~ /raw_tile_\d_image/ }.map do |b|
      {
        identifier: b[:identifier].sub('image', 'srcset'),
        content: srcset_content(original_url: b[:content]).join(', ')
      }
    end
  end
end
