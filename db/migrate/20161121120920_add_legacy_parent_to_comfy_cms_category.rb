class AddLegacyParentToComfyCmsCategory < ActiveRecord::Migration
  def change
    add_column :comfy_cms_categories, :legacy_parent_id, :integer
  end
end
