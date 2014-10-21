class VersionsController < ApplicationController
  def show
    render file: File.expand_path('../../../public/version', __FILE__), layout: false
  end
end
