class NotesController < Comfy::Admin::Cms::BaseController
  def create
    @page  = @site.pages.find(params[:page_id])
    @note  = @page.revisions.create!(data: {
      note: { to: params[:description] },
      author: {
        id: current_user.id,
        name: current_user.name
      }
    })
    render nothing: true
  end
end
