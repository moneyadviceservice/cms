class Links::PagesController < ApplicationController
  def index
    pages  = Comfy::Cms::Page.includes(:site).published
    pages  = Comfy::Cms::Search.new(pages, params[:search]).results

    @pages = PageMirror.collect(pages)
  end
end

