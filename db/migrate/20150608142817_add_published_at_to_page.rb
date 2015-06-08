class AddPublishedAtToPage < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :published_at, :datetime, null: true
  end
end
