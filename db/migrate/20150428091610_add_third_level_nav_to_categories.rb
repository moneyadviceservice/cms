class AddThirdLevelNavToCategories < ActiveRecord::Migration
  def change
    add_column :comfy_cms_categories, :third_level_navigation, :boolean, default: false
  end
end
