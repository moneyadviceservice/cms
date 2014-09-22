require 'spec_helper'

describe "#highlighted_terms" do
  class TestHelper
    include ActionView::Helpers
    include Cms::ViewMethods::Helpers
  end

  subject { TestHelper.new }
  let(:content) { "Some Words" }

  it "returns the original content when no term is provided" do
    expect(subject.highlighted_terms(content)).to eq(content + "\n")
  end

  it "highlights the matching terms" do
    expect(subject.highlighted_terms(content, 'word')).to eq("Some <b>Words</b>")
  end

  it "doesn't highlight non matching terms" do
    expect(subject.highlighted_terms(content, 'no match')).to eq(content)
  end
end
