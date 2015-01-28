class AddOrdinalToCategorizations < ActiveRecord::Migration
  def change
    add_column :comfy_cms_categorizations, :ordinal, :integer, default: 999
  end
end
