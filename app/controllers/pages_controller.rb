class PagesController < Comfy::Admin::Cms::PagesController
  before_action :build_file,     only: [:new, :edit]
  before_action :set_categories, only: [:new, :edit]
  before_action :set_pages,      only: :index
  before_action :set_activity_log, only: [:new, :edit]

  protected

  def presenter
    @presenter ||= PagePresenter.new(@page)
  end
  helper_method :presenter

  def save_page
    PageRegister.new(@page, params: params, current_user: current_user).save
    @page.suppress_mirrors_from_links_recirculation
  end

  def set_activity_log
    @activity_logs = ActivityLogPresenter.collect(ActivityLog.fetch(from: @page))
  end

  def set_pages
    @all_pages = Comfy::Cms::Page.includes(:layout, :site)
  end

  def apply_filters
    @pages = @all_pages.filter(params.slice(:category, :layout, :last_edit, :status, :language))

    if params[:search].present?
      Comfy::Cms::Search.new(@pages, params[:search]).results
    else
      @last_published_pages = @all_pages.status(:published).reorder(updated_at: :desc).limit(4)
      @pages.reorder(updated_at: :desc).page(params[:page])
    end
  end

  def build_file
    @file = Comfy::Cms::File.new
  end

  def set_categories
    @categories = Comfy::Cms::CategoriesListPresenter.new(@site.categories.of_type('Comfy::Cms::Page'))
  end
end
