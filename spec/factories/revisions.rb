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
end
