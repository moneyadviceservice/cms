require Rails.root.join('lib', 'cms', 'publish_scheduled_pages_task.rb')

RSpec.describe PublishScheduledPagesTask do
  describe '.run' do
    let!(:publish_later_today) do
      create :page,
             state: :scheduled,
             scheduled_on: Time.current.end_of_day - 2.hours
    end
    let!(:publish_now) do
      create :page,
             state: :scheduled,
             scheduled_on: Time.current
    end
    let!(:publish_tomorrow) do
      create :page,
             state: :scheduled,
             scheduled_on: Time.current.end_of_day + 1.day
    end

    before(:each) do
      PublishScheduledPagesTask.run
    end

    it 'sets published_at for pages scheduled for release today' do
      expect(publish_later_today.reload.published_at).to eql(publish_later_today.scheduled_on)
      expect(publish_now.reload.published_at).to eql(publish_now.scheduled_on)
    end

    it 'does not update any pages scheduled in the future' do
      expect(publish_tomorrow.published_at).to be_nil
    end
  end
end
