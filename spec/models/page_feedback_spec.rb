RSpec.describe PageFeedback, type: :model do
  it { is_expected.to belong_to(:page) }

  describe 'validations' do
    it { should validate_presence_of(:page) }
  end
end
