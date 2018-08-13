module PageRevisionHelpers
  def latest_revision(page)
    page.revisions.order('id').last
  end

  def latest_revision_attributes(page)
    latest_revision(page).data[:blocks_attributes]
  end

  def latest_revision_content(page)
    latest_revision(page).data[:blocks_attributes].find { |a| a[:identifier] == 'content' }[:content]
  end
end
