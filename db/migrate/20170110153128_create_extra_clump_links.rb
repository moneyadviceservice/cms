class CreateExtraClumpLinks < ActiveRecord::Migration
  def change
    Clump.all.each do |clump|
      (4 - clump.clump_links.count).times do
        clump.clump_links.create!
      end
    end
  end
end
