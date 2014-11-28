class FilesController < Comfy::Admin::Cms::FilesController
  before_action :check_files_existence, only: :index
  before_action :set_categories, only: [:new, :edit]

  def index
    @order = params[:order].presence
    @type  = params[:type].presence
    @files = @site.files.not_page_file
      .includes(:categories)
      .for_category(params[:category])
      .of_type(@type)
      .search_by(params[:search])
      .ordered_by(@order)
      .page(params[:page])
  end

  private

  def check_files_existence
    redirect_to(action: :new) if @site.files.count == 0
  end

  def build_file
    @file = @site.files.new
  end

  def set_categories
    categories  = @site.categories.of_type(@file.class.to_s)
    @categories = Comfy::Cms::CategoriesListPresenter.new(categories)
  end
end
