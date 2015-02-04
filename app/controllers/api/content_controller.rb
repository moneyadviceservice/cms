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
      @page ||= if page_type.present? && page_type_supported?
                  current_site.pages
                    .published
                    .joins(:layout)
                    .find_by(slug: params[:slug], 'comfy_cms_layouts.identifier' => page_type)
                else
                  current_site.pages.find_by(slug: params[:slug])
                end
    end

    def page_type_supported?
      page_type.in?(current_site.layouts.pluck(:identifier))
    end

    def page_type
      @page_type ||= params[:page_type].to_s.singularize
    end
  end
end
