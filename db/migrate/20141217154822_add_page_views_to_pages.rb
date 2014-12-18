class AddPageViewsToPages < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :page_views, :integer, default: 0
  end
end
