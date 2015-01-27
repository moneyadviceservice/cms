class CategoryContentsController < Comfy::Cms::ContentController
  skip_before_action :load_cms_page

  def index
    # @categories = Comfy::Cms::Categories.all
    respond_to do |format|
      format.json { render json: {} }
    end
  end
end
