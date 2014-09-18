class AddMetaDesctiption < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :meta_description, :string
  end
end
