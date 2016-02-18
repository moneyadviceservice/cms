require_relative './edit'

module UI::Pages
  class AlternateEdit < Edit
    set_url '/admin/sites/{site}/pages/{page}/edit?alternate=true'
    set_url_matcher /\admin\/sites\/\d+\/pages\/\d+\/edit\?alternate\=true/
  end
end
