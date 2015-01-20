class HipposController < Comfy::Admin::Cms::BaseController
  before_action :check_admin

  def new
    @hippo_importer_form = HippoImporterForm.new
  end

  def create
    @hippo_importer_form = HippoImporterForm.new(params[:hippo_importer_form])
    @records = Cms::HippoImporter.migrate(@hippo_importer_form) if @hippo_importer_form.valid?
    render :new
  end
end
