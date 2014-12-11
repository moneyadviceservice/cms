class Links::DocumentsController < Links::FilesController
  def index
    super

    @files = @files.not_images
  end
end
