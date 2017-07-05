class PublishScheduledPagesTask
  def self.run
    Comfy::Cms::Page.scheduled_today.each do |page|
      page.published_at = page.scheduled_on
      page.save!
    end
  end
end
