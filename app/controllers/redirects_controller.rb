class RedirectsController < Comfy::Admin::Cms::BaseController
  def new
    @redirect = Redirect.new
  end

  def create
    @redirect = Redirect.new(redirect_params)

    if @redirect.save
      flash[:success] = 'Successfully created redirect'
      redirect_to redirects_path
    else
      flash[:danger] = @redirect.errors.full_messages.join(', ')
      render :new
    end
  end

  def index
    @redirects = Redirect.recently_updated_order.includes(:versions).all
  end

  def search
    @redirects = Redirect.search(search_params[:query]).recently_updated_order.includes(:versions).all

    render :index
  end

  private

  def redirect_params
    params.require(:redirect).permit(:source, :destination, :redirect_type)
  end

  def search_params
    params.require(:redirect_search).permit(:query)
  end
end
