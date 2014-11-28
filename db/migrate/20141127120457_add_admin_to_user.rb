class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :comfy_cms_users, :admin, :boolean, default: false
  end
end
