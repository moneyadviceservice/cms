class RedirectsController < Comfy::Admin::Cms::BaseController
  before_action :check_admin

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

  def show
    @redirect = Redirect.find(params[:id])
  end

  def update
    @redirect = Redirect.find(params[:id])

    if @redirect.update(redirect_params)
      flash[:success] = 'Successfully updated redirect'
      redirect_to redirects_path
    else
      flash[:danger] = @redirect.errors.full_messages.join(', ')
      render :show
    end
  end

  def index
    @redirects = Redirect.recently_updated_order.includes(:versions).page(params[:page])
  end

  def destroy
    @redirect = Redirect.find(params[:id])
    @redirect.inactivate!

    redirect_to redirects_path
  end

  def search
    @redirects = Redirect.search(search_params[:query]).recently_updated_order.includes(:versions).page(params[:page])
    @query = search_params[:query]

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
