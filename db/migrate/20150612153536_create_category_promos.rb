class CreateCategoryPromos < ActiveRecord::Migration
  def change
    create_table :category_promos do |t|
      t.string :promo_type, null: true
      t.string :title, null: false
      t.string :description, null: true
      t.string :locale, null: false
      t.string :url, null: true
      t.integer :category_id, null: false
    end

    add_index :category_promos, :locale
  end
end
