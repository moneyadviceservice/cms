class LinksController < ApplicationController
  def show
    @link = LinkableObject.find(params[:id], link_type: params[:type])

    if @link
      render json: { label: @link.label }
    else
      head :not_found
    end
  end
end
