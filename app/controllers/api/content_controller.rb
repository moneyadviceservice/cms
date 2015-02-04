module API
  class ContentController < APIController
    before_action :find_site, only: [:show, :preview]
    before_action :find_page, only: [:show, :preview]

    def show
      render json: page
    end

    def preview
      render json: page, scope: 'preview'
    end

    private

    def find_page
      render json: { message: 'Page not found' }, status: 404 if page.blank?
    end

    def page
      @page ||= current_site.pages.find_by(slug: params[:slug])
    end
  end
end
