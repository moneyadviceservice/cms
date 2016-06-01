class Links::PagesController < PagesController
  def index
    pages  = Comfy::Cms::Page.includes(:site).where.not(state: :published).filter(params.slice(:category))
    pages  = Comfy::Cms::Search.new(pages, params[:search]).results if params[:search].present?

    @pages = PageMirror.collect(pages)
  end
end
