class AddActiveToRedirects < ActiveRecord::Migration
  def change
    add_column :redirects, :active, :boolean, default: true
  end
end
