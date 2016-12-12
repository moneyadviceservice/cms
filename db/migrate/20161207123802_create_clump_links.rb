class CreateClumpLinks < ActiveRecord::Migration
  def change
    create_table :clump_links do |t|
      t.integer :clump_id
      t.string :text_en
      t.string :text_cy
      t.string :url_en
      t.string :url_cy
      t.string :style

      t.timestamps
    end
  end
end
