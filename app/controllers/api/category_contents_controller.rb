module API
  class InvalidLocale < Exception;  end

  class CategoryContentsController < ApplicationController
    skip_before_action :load_cms_page
    around_filter :validate_locale

    api :GET, '/:locale/categories'
    param :locale, /[en|cy]/, required: true
    def index
      @primary_navigation, @secondary_navigation = Comfy::Cms::Category.navigation_categories
      render json: @primary_navigation, scope: locale
    end

    api :GET, '/:locale/categories/:id'
    param :locale, /[en|cy]/, required: true
    param :id, :number, required: true
    def show
      @category = Comfy::Cms::Category.find_by(label: params[:id])
      render json: @category, scope: locale
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
