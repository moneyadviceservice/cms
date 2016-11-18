class ClumpsController < Comfy::Admin::Cms::BaseController

  def index
    @clumps = Clump.all
  end

end
