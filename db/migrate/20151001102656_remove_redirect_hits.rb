class RemoveRedirectHits < ActiveRecord::Migration
  def change
    remove_column :redirects, :hits, :integer, default: 0
  end
end
