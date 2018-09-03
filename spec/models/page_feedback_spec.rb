RSpec.describe PageFeedback, type: :model do
  it { is_expected.to belong_to(:page) }

  describe 'validations' do
    it { should validate_presence_of(:page) }
    it { should validate_presence_of(:session_id) }
    it { should validate_inclusion_of(:shared_on).in_array(%w[Facebook Twitter Email]) }
  end

  describe 'scopes' do
    let(:page_id) { 1 }

    it '#liked_count' do
      expect(PageFeedback.liked(page_id).to_sql)
        .to eq PageFeedback.where(page: page_id, liked: true).to_sql
    end

    it '#disliked_count' do
      expect(PageFeedback.disliked(page_id).to_sql)
        .to eq PageFeedback.where(page: page_id, liked: false).to_sql
    end
  end

  describe '#to_csv' do
    subject { PageFeedback.to_csv }
    let!(:page_feedback) { create(:page_feedback) }
    let(:header) do
      'page_slug,id,page_id,liked,comment,shared_on,created_at,updated_at,session_id'
    end
    let(:first_row) do
      "#{page_feedback.page_slug},#{page_feedback.id},#{page_feedback.page_id},true,Awesome!,Facebook"
    end

    it 'returns the header' do
      expect(subject).to include(header)
    end

    it 'returns the rows' do
      expect(subject).to include(first_row)
    end
  end
end
