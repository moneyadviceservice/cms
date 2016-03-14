class AddActiveRevisionIdToPages < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :active_revision_id, :integer, after: :id

    add_index :comfy_cms_pages, :active_revision_id

    Comfy::Cms::Page.all.each do |page|
      print "Page #{page.id}, state: #{page.state} - "

      if ['published_being_edited', 'scheduled'].include?(page.state)
        last_published_revision = page.revisions.find { |r| r.data[:previous_event] == 'published' }

        if last_published_revision.present?
          puts "found revision #{last_published_revision.id} with previous_event of 'published', assigning"
          page.update_column(:active_revision_id, last_published_revision.id)
        else
          puts 'no published revision'
        end
      else
        puts 'active revision not applicable in this state'
      end
    end
  end
end
