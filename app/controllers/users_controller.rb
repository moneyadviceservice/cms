class UsersController < Comfy::Admin::Cms::PagesController
  skip_before_action :load_cms_page
  skip_before_action :build_file

  def index
    @users = Comfy::Cms::User.all
    render cms_site: Comfy::Cms::Site.first.identifier
  end

  def new
    @user = Comfy::Cms::User.new
  end

  def create
    @user = Comfy::Cms::User.new(user_params)
    if @user.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @user = Comfy::Cms::User.find(params[:id])
    render cms_site: Comfy::Cms::Site.first.identifier
  end

  def update
    @user = Comfy::Cms::User.find(params[:id])
    @user.update_attributes!(user_params.reject { |_, k| k.blank? })
    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = "Failed to update #{@user.errors.full_messages}"
    render action: :edit
  end

  def destroy
    @user = Comfy::Cms::User.find(params[:id])
    @user.destroy
    redirect_to action: :index
  end

  private

  def user_params
    params.require(:comfy_cms_user).permit(:email, :password, :name)
  end
end
