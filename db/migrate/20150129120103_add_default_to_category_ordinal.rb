class AddDefaultToCategoryOrdinal < ActiveRecord::Migration
  def change
    change_column :comfy_cms_categories, :ordinal, :integer, default: 999
  end
end
