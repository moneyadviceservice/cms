require 'rspec/expectations'

RSpec::Matchers.define :contain_article_label do |expected_label, expected_page_views = nil|
  match do |actual|
    actual.each do |google_result_hash|
      label_matches = expected_label == google_result_hash[:label]
      page_views_matches = expected_page_views.present? ? expected_page_views == google_result_hash[:page_views] : true
      return true if label_matches && page_views_matches
    end

    false
  end
end
