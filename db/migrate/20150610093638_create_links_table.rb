class CreateLinksTable < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :linkable_type, null: false
      t.integer :linkable_id, null: false
      t.string :text, null: false
      t.string :url, null: false
      t.string :locale, null: false
    end
  end
end
