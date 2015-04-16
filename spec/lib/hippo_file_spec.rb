RSpec.describe HippoFile do
  describe "#blob" do
    let(:subject) do
      element = Nokogiri::XML(file).xpath('//sv:property[@sv:type="Binary"]')[0].parent
      described_class.new(element)
    end

    context "only contains hippo data" do
      let(:file) { File.read(Rails.root.join('spec', 'fixtures', 'hippo_blob.xml')) }

      it "returns the hippo blob" do
        expect(subject.blob).to eq('hippo blob')
      end
    end

    context "only contains jcr data" do
      let(:file) { File.read(Rails.root.join('spec', 'fixtures', 'jcr_blob.xml')) }

      it "returns the jcr blob" do
        expect(subject.blob).to eq('jcr blob')
      end
    end

    context "contains both hippo and jcr data" do
      let(:file) { File.read(Rails.root.join('spec', 'fixtures', 'hippo_and_jcr_blobs.xml')) }

      it "returns the jcr blob" do
        expect(subject.blob).to eq('jcr blob')
      end
    end
  end
end
