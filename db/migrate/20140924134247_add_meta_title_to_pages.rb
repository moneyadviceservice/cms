class AddMetaTitleToPages < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :meta_title, :string
  end
end
