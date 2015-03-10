class Hippo::DiffsController < Comfy::Admin::Cms::BaseController
  before_action :check_admin

  def show
    @hippo_diff = Cms::HippoDiff.new(data: data)
  end

  private

  def data
    File.read(Rails.root.join('tmp', filename))
  end

  def filename
    if params[:welsh].blank?
      'contentauthoringwebsite.xml'
    else
      'contentauthoringwebsite-welsh.xml'
    end
  end
end
