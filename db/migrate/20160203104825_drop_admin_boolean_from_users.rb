class DropAdminBooleanFromUsers < ActiveRecord::Migration
  def up
    remove_column :comfy_cms_users, :admin
  end

  def down
    add_column :comfy_cms_users, :admin, :boolean, default: false
  end
end
