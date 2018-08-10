class FilesController < Comfy::Admin::Cms::FilesController
  before_action :check_files_existence, only: :index
  before_action :set_categories, only: %i[new edit]
  before_action :set_file_presenter, only: %i[new edit]
  after_action :set_files_presenter, only: :index

  def index
    @order = params[:order].presence
    @type  = params[:type].presence
    @files = Comfy::Cms::File.not_page_file
                             .includes(:categories)
                             .for_category(params[:category])
                             .of_type(@type)
                             .search_by(params[:search])
                             .ordered_by(@order)
                             .page(params[:page])
  end

  private

  def check_files_existence
    redirect_to(action: :new) if Comfy::Cms::File.count.zero?
  end

  def set_files_presenter
    @files = FilePresenter.collect(@files)
  end

  def set_file_presenter
    @file_presenter = FilePresenter.new(@file)
  end

  def build_file
    @file = @site.files.new
  end

  def set_categories
    categories  = @site.categories.of_type(@file.class.to_s)
    @categories = Comfy::Cms::CategoriesListPresenter.new(categories)
  end
end
