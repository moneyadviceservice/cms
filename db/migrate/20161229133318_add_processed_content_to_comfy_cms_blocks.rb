class AddProcessedContentToComfyCmsBlocks < ActiveRecord::Migration
  def change
    add_column :comfy_cms_blocks, :processed_content, :text, limit: 16.megabytes - 1
  end
end
