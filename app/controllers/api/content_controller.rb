module API
  class ContentController < Comfy::Cms::ContentController
    def show
      respond_with(@cms_page) do |format|
        format.json { render json: @cms_page }
        format.html { render_html }
      end
    end

    def preview
      @cms_page = @cms_site.pages.with_slug("#{params[:cms_path]}")

      respond_with(@cms_page) do |format|
        format.json { render json: @cms_page, scope: 'preview' }
        format.html { render_html }
      end
    end
  end
end
