class AddAmpSupportFieldForPages < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :supports_amp, :boolean, default: true
  end
end
