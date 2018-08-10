class VersionsController < ApplicationController
  def show
    render file: File.expand_path('../../public/version', __dir__), layout: false
  end
end
