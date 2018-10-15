module API
  class InvalidLocale < Exception; end

  class ClumpsController < ApplicationController
    skip_before_action :load_cms_page
    around_filter :validate_locale

    def index
      @clumps = Clump.all
      render json: @clumps, scope: locale
    end

    private

    def locale
      fail InvalidLocale.new unless params[:locale].in?(accepted_locales)

      params[:locale]
    end

    def validate_locale
      yield
    rescue InvalidLocale
      render json: {
        error: "Unaccepted locale (must be #{accepted_locales.join(' ')})"
      }, status: 400
    end

    def accepted_locales
      @accepted_locales ||= Comfy::Cms::Site.pluck(:path)
    end
  end
end
