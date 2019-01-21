FactoryGirl.define do
  factory :revision, class: Comfy::Cms::Revision do
    transient do
      content 'some content'
    end

    association :record, factory: :page
    data {
      {
        blocks_attributes: [
          { identifier: 'content', content: content }
        ]
      }
    }
  end

  factory :revision_with_event, class: Comfy::Cms::Revision do
    transient do
      user_id 1
      user_name 'Test User'
    end

    association :record, factory: :page
    data {
      {
        event: 'published',
        author: { id: user_id, name: user_name }
      }
    }
  end
end
