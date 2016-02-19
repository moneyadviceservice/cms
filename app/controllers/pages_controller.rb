class PagesController < Comfy::Admin::Cms::PagesController

  before_action :check_permissions

  def index
    @all_pages = Comfy::Cms::Page.includes(:layout, :site, :categories)

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

  def check_permissions
    if PermissionCheck.new(current_user, @page, action_name, params[:state_event]).fail?
      flash[:danger] = 'Insufficient permissions to change'
      redirect_to comfy_admin_cms_site_pages_path(params[:site_id])
    end
  end
end
