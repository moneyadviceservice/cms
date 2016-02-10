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

    it { is_expected.to validate_uniqueness_of(:source).scoped_to(:active) }

    it { is_expected.to validate_inclusion_of(:redirect_type).in_array(described_class::REDIRECT_TYPES) }

    it 'validates source and destination not identical' do
      subject.destination = 'foo'
      expect(subject).to_not be_valid
    end

    context 'when a redirect alreay exists' do
      before :each do
        described_class.create!(valid_attributes)
      end

      it 'can not chain' do
        subject.source = '/en/other-source'
        subject.destination = '/en/foo'
        expect(subject).to_not be_valid
      end

      it 'can not chain' do
        subject.source = '/en/bar'
        subject.destination = '/en/other-destination'
        expect(subject).to_not be_valid
      end

      it 'can not loop' do
        subject.source = '/en/bar'
        subject.destination = '/en/foo'
        expect(subject).to_not be_valid
      end
    end

    describe 'chaining with utm parameters' do
      context 'creating the first part' do
        let!(:second) do
          described_class.create!(source: '/en/middle',
                                  destination: '/en/final',
                                  redirect_type: 'temporary')
        end

        subject do
          described_class.new(source: '/en/origin',
                              destination: '/en/middle?utma=a',
                              redirect_type: 'temporary')
        end

        it 'is invalid' do
          expect(subject).to_not be_valid
        end
      end

      context 'creating the second part' do
        let!(:first) do
          described_class.create!(source: '/en/origin',
                                  destination: '/en/middle?utma=a',
                                  redirect_type: 'temporary')
        end

        subject do
          described_class.new(source: '/en/middle',
                              destination: '/en/final',
                              redirect_type: 'temporary')
        end

        it 'is invalid' do
          expect(subject).to_not be_valid
        end
      end
    end

    describe 'modifying an existing record' do
      it 'does not perform validations against itself' do
        subject.save!

        subject.source = valid_attributes[:destination]
        subject.destination = valid_attributes[:source]

        subject.save!
      end
    end

    describe 'format validation' do
      context 'for source' do
        it 'must begin with /' do
          subject.source = '/en/foo'
          expect(subject).to be_valid

          subject.source = 'foo'
          expect(subject).to_not be_valid
        end

        it 'must not contain a hash character' do
          subject.source = '/en/foo#anchor'
          expect(subject).to_not be_valid
        end

        it 'can not end with a dot' do
          subject.source = '/en/foo.'
          expect(subject).to_not be_valid
        end

        it 'can only end in allowed extensions' do
          %w(html pdf aspx).each do |allowed|
            subject.source = "/en/foo.#{allowed}"
            expect(subject).to be_valid
          end

          %w(jpg png json).each do |not_allowed|
            subject.source = "/en/foo.#{not_allowed}"
            expect(subject).to_not be_valid
          end
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

  describe '#source' do
    it 'removes any trailing slashes' do
      subject.source = '/en/foo////'
      subject.valid?
      expect(subject.source).to eql('/en/foo')
    end
  end

  describe '#destination' do
    it 'removes any trailing slashes' do
      subject.destination = '/en/foo////'
      subject.valid?
      expect(subject.destination).to eql('/en/foo')
    end

    it 'removes any trailing hashes' do
      subject.destination = '/en/foo####'
      subject.valid?
      expect(subject.destination).to eql('/en/foo')
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

  describe '#inactivate!' do
    subject do
      described_class.create!(valid_attributes)
    end

    it 'marks the record as inactive' do
      subject.inactivate!
      expect(subject.reload.active).to be_falsey
    end

    it 'can create another redirect with same source' do
      subject.inactivate!
      expect do
        described_class.create!(valid_attributes)
      end.to_not raise_error
    end

    context 'inactivating a duplicate redirect' do
      let(:first) { described_class.create!(valid_attributes) }

      before :each do
        first.inactivate!
      end

      subject do
        described_class.create!(valid_attributes)
      end

      it 'can be inactivated' do
        subject.inactivate!
        expect(subject.reload.active).to be_falsey
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
