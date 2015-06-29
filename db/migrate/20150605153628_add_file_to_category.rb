class AddFileToCategory < ActiveRecord::Migration
  def change
    add_column :comfy_cms_categories, :small_image_id, :integer, null: true
    add_column :comfy_cms_categories, :large_image_id, :integer, null: true
  end
end
