class PagesController < Comfy::Admin::Cms::PagesController

  def index
    @all_pages = Comfy::Cms::Page.includes(:layout, :site, :categories)

    super
  end

  def new
    @file = Comfy::Cms::File.new
  end

  def create
    @file = Comfy::Cms::File.new

    super
  end

  protected

  def presenter
    @presenter ||= PagePresenter.new(@page)
  end
  helper_method :presenter

  def save_page
    PageRegister.new(@page, params: params, current_user: current_user).save
    CategoryMirror.new.assign_categories_to_mirrors(@page.categories, @page.mirrors)
    @page.suppress_mirrors_from_links_recirculation
  end

  def apply_filters
    @pages = @all_pages.filter(params.slice(:category, :layout, :last_edit, :status, :language))

    if params[:search].present?
      Comfy::Cms::Search.new(@pages, params[:search]).results
    else
      @last_published_pages = @all_pages.status(:published).reorder(updated_at: :desc).limit(4)
      @last_draft_pages = @all_pages.status(:draft).reorder(updated_at: :desc).limit(4)
      @pages.reorder(updated_at: :desc).page(params[:page])
    end
  end

end
