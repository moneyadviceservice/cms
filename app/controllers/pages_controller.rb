class PagesController < Comfy::Admin::Cms::PagesController
  before_action :build_file,     only: [:new, :edit]
  before_action :set_categories, only: [:new, :edit]
  before_action :set_pages,      only: :index

  protected

  def set_pages
    @pages = @site.pages.includes(:layout, :site).page params[:page]
  end

  def apply_filters
    @filters_present = params[:category].present? || params[:search].present?

    if params[:search].present?
      @pages = Comfy::Cms::Search.new(@pages, params[:search]).results
    else
      @pages = @pages.filter(params.slice(:category, :layout, :last_edit, :status, :language))
    end
  end

  def build_file
    @file = Comfy::Cms::File.new
  end

  def set_categories
    @categories = Comfy::Cms::CategoriesListPresenter.new(@site.categories.of_type('Comfy::Cms::Page'))
  end

  def state_event
    @state_event ||= params[:state_event]
  end
end

