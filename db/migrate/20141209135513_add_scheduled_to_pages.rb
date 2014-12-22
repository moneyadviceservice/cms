class AddScheduledToPages < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :scheduled_on, :datetime
  end
end
