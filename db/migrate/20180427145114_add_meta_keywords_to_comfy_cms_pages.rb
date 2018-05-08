class AddMetaKeywordsToComfyCmsPages < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :meta_keywords, :string
  end
end
