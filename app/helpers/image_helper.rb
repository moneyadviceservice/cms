module ImageHelper
  # srcset_image_tag(image)
  # params:
  #   image => Expects an image file attached using Paperclip
  #
  def srcset_image_tag(image)
    image = FilePresenter.new(image)
    image_tag(image.full_path(style: :original), alt: '', srcset: generate_srcset(image))
  end

  private
  def generate_srcset(image)
    srcset = []
    %w(extra_small small medium large).each_with_index do |style, i|
      srcset << "#{image.full_path(style: style)} #{i+1}x"
    end
    srcset.join(', ').strip
  end
end
