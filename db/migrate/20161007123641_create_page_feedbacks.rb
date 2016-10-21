class CreatePageFeedbacks < ActiveRecord::Migration
  def change
    create_table :page_feedbacks do |t|
      t.integer :page_id
      t.boolean :liked, default: true
      t.text :comment
      t.string :shared_on

      t.timestamps
    end

    add_index :page_feedbacks, :page_id
    add_index :page_feedbacks, [:page_id, :liked]
  end
end
