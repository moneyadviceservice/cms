describe Redirect do
  let(:valid_attributes) do
    {
      source: '/en/foo',
      destination: '/en/bar',
      redirect_type: 'temporary'
    }
  end

  describe 'validations' do
    subject do
      described_class.new(valid_attributes)
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
      context 'for source' do
        it 'must begin with /' do
          subject.source = '/en/foo'
          expect(subject).to be_valid

          subject.source = 'foo'
          expect(subject).to_not be_valid
        end
      end

      context 'for destination' do
        it 'must begin with /en or /cy' do
          subject.destination = '/en/asd'
          expect(subject).to be_valid

          subject.destination = '/cy/foo'
          expect(subject).to be_valid

          subject.destination = '/foo'
          expect(subject).to_not be_valid
        end
      end
    end
  end

  describe 'audit' do
    let(:valid_attributes) do
      {
        source: '/en/foo',
        destination: '/en/bar',
        redirect_type: 'temporary'
      }
    end

    context 'when creating' do
      subject do
        described_class.create!(valid_attributes)
      end

      it 'is audited' do
        with_versioning do
          expect { subject }.to change(RedirectVersion, :count).by(1)
        end
      end
    end
  end

  describe '::search' do
    context 'when there are no matches' do
      it 'returns an empty array' do
        expect(described_class.search('blank')).to be_empty
      end
    end

    context 'when there is match' do
      before :each do
        described_class.create!(valid_attributes)
      end

      it 'searches source' do
        expect(described_class.search('foo')).to be_present
      end

      it 'searches destination' do
        expect(described_class.search('bar')).to be_present
      end
    end
  end
end
