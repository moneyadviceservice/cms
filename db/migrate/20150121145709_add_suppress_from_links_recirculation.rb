class AddSuppressFromLinksRecirculation < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :suppress_from_links_recirculation, :boolean, default: false
  end
end
