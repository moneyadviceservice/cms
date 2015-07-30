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

  private

  def redirect_params
    params.require(:redirect).permit(:source, :destination, :redirect_type)
  end
end
