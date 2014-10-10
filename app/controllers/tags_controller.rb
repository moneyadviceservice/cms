class TagsController < Comfy::Admin::Cms::BaseController
  respond_to :js, only: [:create, :starting_by, :delete_from_value]

  # Filters
  before_action :build_tag_from_params, only: [:create]
  before_action :find_tag_from_params,  only: [:delete_from_value]


  def index
  end

  def create
    render js: "#{@tag.save}"
  end

  # Tags starting by a given prefix.
  def starting_by
    @prefix = starting_prefix_param
    @tags   = Tag.starting_by(@prefix)
  end

  def delete_from_value
    @tag.destroy unless @tag.in_use?
    render js: "#{@tag.destroyed?}"
  end


  private

  # Filters

  def build_tag_from_params
    @tag = Tag.new(tag_params)
  end

  def find_tag_from_params
    @tag = Tag.valued(tag_params).first
  end


  # Params

  def tag_params
    params.require(:tag).permit(:value)
  end

  def starting_prefix_param
    params.require(:prefix)
  end

end
