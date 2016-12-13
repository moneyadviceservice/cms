class CreateClumpings < ActiveRecord::Migration
  def change
    create_table :clumpings do |t|
      t.integer :clump_id
      t.integer :category_id
      t.integer :ordinal

      t.timestamps
    end
  end
end
