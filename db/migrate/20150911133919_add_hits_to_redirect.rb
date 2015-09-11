class AddHitsToRedirect < ActiveRecord::Migration
  def change
    add_column :redirects, :hits, :integer, default: 0
  end
end
