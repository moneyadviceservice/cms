class Links::ImagesController < Links::FilesController
  def index
    super

    @files = @files.images.map do |f|
      f.tap { |o| o.style = avalaible_styles.fetch(params[:style], :original) }
    end
  end

  private

  def avalaible_styles
    @as ||= Comfy::Cms::File.new.file.styles.keys
      .each_with_object({}) do |e, hsh|
        v = e.to_s.freeze
        k = v.split('_')[1].freeze
        hsh[k] = e if v =~ /png_1x/
    end
  end
end
