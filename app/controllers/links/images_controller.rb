class Links::ImagesController < Links::FilesController
  def index
    super

    @files = @files.images.map { |f| f.tap { |o| o.style = image_style } }
  end

  private

  def image_style
    @image_style ||= if available_image_styles.include?(params[:style])
      "hp_#{params[:style]}_png_1x".to_sym
    else
      :original
    end
  end

  def available_image_styles
    @available_image_styles ||= Set.new(Comfy::Cms::File.new.file.styles.keys.map(&:to_s).map {|s| s.split('_')[1] })
  end
end
