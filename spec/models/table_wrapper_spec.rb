describe TableWrapper do
  context 'when there is no table' do
    let(:source) { '<p>hello</p>' }

    subject do
      described_class.new(source)
    end

    it 'does nothing' do
      expect(subject.call).to eql(source)
    end
  end

  context 'when there is a table' do
    let(:source) { '<table></table>' }

    subject do
      described_class.new(source)
    end

    it 'wraps the table' do
      expect(subject.call).to eql('<div class="table-wrapper"><table></table></div>')
    end
  end
end
