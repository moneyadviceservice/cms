class ChangeMetaKeywordsTypeToComfyCmsPages < ActiveRecord::Migration
  def change
    change_column :comfy_cms_pages, :meta_keywords, :text
  end
end
