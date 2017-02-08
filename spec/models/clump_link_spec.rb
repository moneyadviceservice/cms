describe ClumpLink do
  describe 'validations' do
    context 'with no fields complete' do
      it { should_not validate_presence_of(:text_en) }
      it { should_not validate_presence_of(:text_cy) }
      it { should_not validate_presence_of(:url_en) }
      it { should_not validate_presence_of(:url_cy) }
      it { should_not validate_presence_of(:style) }
    end

    context 'with some of the fields complete' do
      before { subject.text_en = subject.url_en = 'x' }

      it { should validate_presence_of(:text_en) }
      it { should validate_presence_of(:text_cy) }
      it { should validate_presence_of(:url_en) }
      it { should validate_presence_of(:url_cy) }
      it { should validate_presence_of(:style) }
    end
  end

  describe '#empty?' do
    context 'if all attributes are blank' do
      it { should be_empty }
    end

    context 'if an attribute is an empty string' do
      before { subject.text_en = '' }
      it { should be_empty }
    end

    context 'if an attribute is present' do
      before { subject.text_en = 'x' }
      it { should_not be_empty }
    end

    context 'if all attributes are present' do
      before do
        subject.text_en = subject.text_cy = subject.url_en = subject.url_cy = subject.style = 'x'
      end

      it { should_not be_empty }
    end
  end

  describe '#complete?' do
    context 'with all attributes are present' do
      before do
        subject.text_en = subject.text_cy = subject.url_en = subject.url_cy = subject.style = 'x'
      end

      it { should be_complete }

      context 'but one is an empty string' do
        before { subject.text_en = '' }
        it { should_not be_complete }
      end

      context 'but one is nil' do
        before { subject.text_en = nil }
        it { should_not be_complete }
      end
    end

    context 'with no attributes present' do
      it { should_not be_complete }
    end
  end
end
