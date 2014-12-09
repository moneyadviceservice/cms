class Links::FilesController < FilesController
  def index
    super

    @files = @files.not_images
  end

  private

  def check_files_existence
    false
  end
end
