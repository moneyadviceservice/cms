class ClumpsController < Comfy::Admin::Cms::BaseController
  PERMITTED_PARAMS = [
    :name_en, :name_cy,
    :description_en, :description_cy,
    clump_links_attributes: %i[
      id
      text_en text_cy
      url_en url_cy
      style
    ]
  ].freeze
  def index
    @clumps = Clump.order('ordinal ASC')
  end

  def show
    @clump = Clump.find(params[:id])
  end

  def new
    @clump = Clump.new do |clump|
      4.times { clump.clump_links.build }
    end
  end

  def create
    @clump = Clump.new(clump_params)
    if @clump.save
      redirect_to clump_path(@clump)
    else
      render :new
    end
  end

  def update
    @clump = Clump.find(params[:id])
    begin
      Clump.transaction do
        @clump.update!(clump_params)
        params[:category_order].split(',').each_with_index do |category_id, index|
          @clump.clumpings.find_by(category_id: category_id).update_column(:ordinal, index)
        end
      end
      redirect_to clump_path(@clump)
    rescue ActiveRecord::RecordInvalid
      render :show
    end
  end

  def reorder
    Clump.transaction do
      params[:order].split(',').each_with_index do |clump_id, index|
        Clump.find(clump_id).update_column(:ordinal, index)
      end
    end

    redirect_to clumps_path
  end

  def clump_params
    params.require(:clump).permit(PERMITTED_PARAMS)
  end
end
