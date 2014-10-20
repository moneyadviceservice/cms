class AddIndexToTags < ActiveRecord::Migration

  def change
    add_index :tags, :value, unique: true
  end

end
