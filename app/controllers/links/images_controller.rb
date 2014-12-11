class Links::ImagesController < Links::FilesController
  def index
    super

    @files = @files.images
  end
end
