describe Redirect do
  describe 'validations' do
    subject do
      described_class.new(source: 'foo',
                          destination: 'bar',
                          redirect_type: 'temporary')
    end

    it { is_expected.to validate_presence_of(:source)  }
    it { is_expected.to validate_presence_of(:destination)  }
    it { is_expected.to validate_presence_of(:redirect_type)  }

    it { is_expected.to validate_uniqueness_of(:source) }

    it { is_expected.to validate_inclusion_of(:redirect_type).in_array(described_class::REDIRECT_TYPES) }

    it 'validates source and destination not identical' do
      subject.destination = 'foo'
      expect(subject).to_not be_valid
    end

    describe 'format validation' do
      it 'must begin with /en or /cy' do
        subject.destination = '/en/foo'
        expect(subject).to be_valid

        subject.destination = '/cy/foo'
        expect(subject).to be_valid

        subject.destination = '/foo'
        expect(subject).to_not be_valid
      end
    end
  end
end
