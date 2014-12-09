class LinksController < ApplicationController
  def show
    link = LinkableObject.find(params[:id])

    render json: link, serializer: LinkSerializer
  end
end
