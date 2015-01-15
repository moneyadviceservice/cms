class AddCategoryInformation < ActiveRecord::Migration
  def change
    add_column :comfy_cms_categories, :title_en, :string
    add_column :comfy_cms_categories, :title_cy, :string
    add_column :comfy_cms_categories, :description_en, :string
    add_column :comfy_cms_categories, :description_cy, :string
    add_column :comfy_cms_categories, :title_tag_en, :string
    add_column :comfy_cms_categories, :title_tag_cy, :string
    add_column :comfy_cms_categories, :parent_id, :integer
    add_column :comfy_cms_categories, :ordinal, :integer
    add_column :comfy_cms_categories, :navigation, :boolean
    add_column :comfy_cms_categories, :image, :string
    add_column :comfy_cms_categories, :preview_image, :string

    add_index :comfy_cms_categories, :parent_id
  end
end
