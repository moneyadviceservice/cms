class Admin::TaggsController < Comfy::Admin::Cms::BaseController

  before_action :build_tagg,  :only => [:new, :create]
  before_action :load_tagg,   :only => [:show, :edit, :update, :destroy]

  def index
    @taggs = Tagg.page(params[:page])
  end

  def show
    render
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @tagg.save!
    flash[:success] = 'Tagg created'
    redirect_to :action => :show, :id => @tagg
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Tagg'
    render :action => :new
  end

  def update
    @tagg.update_attributes!(tagg_params)
    flash[:success] = 'Tagg updated'
    redirect_to :action => :show, :id => @tagg
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Tagg'
    render :action => :edit
  end

  def destroy
    @tagg.destroy
    flash[:success] = 'Tagg deleted'
    redirect_to :action => :index
  end

protected

  def build_tagg
    @tagg = Tagg.new(tagg_params)
  end

  def load_tagg
    @tagg = Tagg.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Tagg not found'
    redirect_to :action => :index
  end

  def tagg_params
    params.fetch(:tagg, {}).permit(:value)
  end
end