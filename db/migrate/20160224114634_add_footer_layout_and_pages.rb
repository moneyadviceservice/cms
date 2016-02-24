class AddFooterLayoutAndPages < ActiveRecord::Migration
  def up
    Cms::LayoutBuilder.add_footer!
    Cms::PageBuilder.add_footer!
  end

  def down
    layouts = Comfy::Cms::Layout.where(label: 'Footer')

    layouts.each do |layout|
      layout.pages.destroy_all
      layout.destroy
    end
  end
end
