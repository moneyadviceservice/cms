class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :comfy_cms_users, :role, :integer
  end
end
