class TagsController < Comfy::Admin::Cms::BaseController
  respond_to :js, only: [:create]

  before_action :build_tag, only: [:create]

  def index
  end

  def create
    render js: "#{@tag.save}"
  end


  private

  def build_tag
    @tag = Tag.new(tag_params)
  end

  def tag_params
    params.fetch(:tag, {}).permit(:value)
  end


end
