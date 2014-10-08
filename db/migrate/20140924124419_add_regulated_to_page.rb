class AddRegulatedToPage < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :regulated, :boolean, :default => false
  end
end
