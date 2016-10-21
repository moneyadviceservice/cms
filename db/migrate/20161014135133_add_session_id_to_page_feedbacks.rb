class AddSessionIdToPageFeedbacks < ActiveRecord::Migration
  def change
    add_column :page_feedbacks, :session_id, :string
    add_index :page_feedbacks, :session_id
  end
end
