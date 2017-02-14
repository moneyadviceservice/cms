module ImageHelper
  # srcset_image_tag(image)
  # params:
  #   image => Expects an image file attached using Paperclip
  #
  #
  def srcset_image_tag(image)
    image_tag(image.file.url, alt: '', srcset: generate_srcset(image))
  end

  private
  def generate_srcset(image)
    file_name, extension = image.file.file_file_name.split '.'

    srcset = []
    [*1..4].each do |i|
      srcset << "#{file_name}-#{i}x.#{extension} #{i}x"
    end
    srcset.join(', ').strip
  end
end
