class TaggingsController < ApplicationController
  respond_to :js

  # Filters
  before_action :find_objects_from_params
  before_action :build_tagging, only: [:create]
  before_action :find_tagging,  only: [:destroy]


  def create
    render js: "#{@tagging.save}"
  end

  def destroy
    @tagging.destroy if @taggging
    render js: "#{@tagging && @tagging.destroyed?}"
  end


  private

  # Filters
  def find_objects_from_params
    find_tag_from_params
    find_taggable_from_params
  end

  def find_tag_from_params
    @tag = Tag.valued(tagging_params[:tag_value]).first
  end

  def find_taggable_from_params
    klass     = tagging_params[:taggable_type].classify.constantize
    @taggable = klass.find(tagging_params[:taggable_id])
  end

  def find_tagging
    @taggable.taggings.where(tag: @tag).first
  end

  def build_tagging
    @tagging = @taggable.taggings.build(tag: @tag)
  end


  # Params
  def tagging_params
    params.require(:tagging).permit(:tag_value, :taggable_id, :taggable_type)
  end

end
