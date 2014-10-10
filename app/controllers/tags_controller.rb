class TagsController < Comfy::Admin::Cms::BaseController
  respond_to :js, only: [:create, :starting_by]

  # Filters
  before_action :build_tag_from_params, only: [:create]


  def index
  end

  def create
    render js: "#{@tag.save}"
  end

  # Tags starting by a given prefix.
  def starting_by
    @prefix = starting_prefix
    @tags   = Tag.starting_by(@prefix)
  end


  private

  # Filters

  def build_tag_from_params
    @tag = Tag.new(tag_params)
  end


  # Params

  def tag_params
    params.fetch(:tag, {}).permit(:value)
  end

  def starting_prefix
    params.require(:prefix)
  end

end
