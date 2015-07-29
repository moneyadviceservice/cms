class CreateRedirects < ActiveRecord::Migration
  def change
    create_table :redirects do |t|
      t.string :source, null: false
      t.string :destination, null: false
      t.string :redirect_type, null: false

      t.timestamps
    end
  end
end
