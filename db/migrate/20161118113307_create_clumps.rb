class CreateClumps < ActiveRecord::Migration
  def change
    create_table :clumps do |t|
      t.string :name_en
      t.string :name_cy
      t.text :description_en
      t.text :description_cy
      t.integer :ordinal

      t.timestamps
    end
  end
end
