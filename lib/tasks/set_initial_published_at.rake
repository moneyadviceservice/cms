##
# This is required as published_at was introduced after many pages had already been published.
# As we can't have a canonical date for articles (due to them being touched nightly in a process that gathers latest and
# popular articles), some of the initial date assignments will be arbitrary; the argument being that an incorrect date
# is less likely to cause harm than a nil one.
##
namespace :published_at do
  desc 'One-shot task to set the initial published_at date on pages that have been published.'
  task set_initial: :environment do
    # don't overwrite any existing published_at dates
    Comfy::Cms::Page.where(published_at: nil).find_each do |page|
      begin
        # If the page is currently published use its updated_at date to get most recent time published.
        # In the case of articles this may not be accurate, but it is better than nothing (see top comment).
        if page.published?
          page.published_at = page.updated_at
        # If a page is not published but has been published at some point, get the created_at date of the last revision
        # that covers a published event.
        elsif page.ever_been_published?
          page.published_at = page.revisions.detect do |revision|
            Array(revision.data[:event]).include?('published')
          end.created_at
        end

        # Note that we don't take scheduled posts into account here as they will update their published_at when
        # published. If they were previously published then the ever_been_published? check will ensure their
        # published_at date is not incorrectly nil.

        page.save!
      rescue Exception => e
        puts "\n----------------"
        puts "Error: page #{page.id} could not be updated."
        puts "Reason: #{e.message}"
        puts e.backtrace.join("\n\t")
        puts "----------------\n"
      end
    end
  end
end
