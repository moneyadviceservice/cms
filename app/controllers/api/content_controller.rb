module API
  class ContentController < APIController
    before_action :find_site, only: [:show, :preview, :published, :unpublished]
    before_action :verify_page_type, only: :show, if: -> { slug.present? }

    def show
      page = if slug.present?
               current_site.pages
                 .published
                 .joins(:layout)
                 .find_by(slug: slug, 'comfy_cms_layouts.identifier' => page_type)
             else
               current_site.pages.published.find_by(slug: params[:page_type])
             end

      render_page(page)
    end

    def preview
      page = current_site.pages.find_by(slug: params[:slug])

      render_page(page, scope: 'preview')
    end

    def published
      pages = current_site.pages.published.layout_identifier(params[:page_type])

      render json: pages, each_serializer: FeedPageSerializer
    end

    def unpublished
      pages = current_site.pages.unpublished.layout_identifier(params[:page_type])

      render json: pages, each_serializer: FeedPageSerializer, scope: 'preview'
    end

    private

    def render_page(page, scope: nil)
      if page
        render json: page, scope: scope
      else
        render json: { message: 'Page not found' }, status: 404
      end
    end

    def verify_page_type
      render json: { message: %(Page type "#{page_type}" not supported) }, status: 400 unless page_type_supported?
    end

    def page_type_supported?
      page_type.in?(current_site.layouts.pluck(:identifier))
    end

    def page_type
      @page_type ||= params[:page_type].to_s.singularize
    end

    def slug
      @slug ||= params[:slug]
    end
  end
end
