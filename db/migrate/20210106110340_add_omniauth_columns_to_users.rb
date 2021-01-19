class AddOmniauthColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :comfy_cms_users, :provider, :string
    add_column :comfy_cms_users, :uid, :string
  end
end
