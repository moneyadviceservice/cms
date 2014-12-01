class UsersController < Comfy::Admin::Cms::BaseController
  before_action :check_admin, except: [:edit, :update]
  before_action :check_user, only: [:edit, :update]

  def index
    @users = Comfy::Cms::User.all
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
    allowed = [:email, :password, :name]
    allowed << :admin if current_user.admin?
    params.require(:comfy_cms_user).permit(allowed)
  end

  def check_user
    return if current_user.admin?
    redirect_to :root unless current_user.to_param == params[:id]
  end
end
