class IndexRedirectSource < ActiveRecord::Migration
  def change
    add_index :redirects, :source
  end
end
