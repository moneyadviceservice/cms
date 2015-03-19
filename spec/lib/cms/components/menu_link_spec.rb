RSpec.describe Cms::Components::MenuLink do
  let(:sublinks) { [] }
  let(:path) { '/admins' }
  subject(:menu_link) { described_class.new(name: 'Admin', path: path, sublinks: sublinks) }

  describe '#sublinks?' do
    context 'when has sublinks' do
      let(:sublinks) { [described_class.new] }

      it 'returns true' do
        expect(menu_link.sublinks?).to be_truthy
      end
    end

    context 'when does not have sublinks' do
      let(:sublinks) { [] }

      it 'returns false' do
        expect(menu_link.sublinks?).to be_falsy
      end
    end
  end

  describe '#add_active_class' do
    let(:path) { '/admins' }
    let(:view) { double(request: double(url: url)) }

    context 'when request is equal to the link path' do
      let(:url) { 'http://test.localhost:3000/admins' }

      it 'returns the active class' do
        expect(menu_link.add_active_class(view)).to eq 'is-active'
      end
    end

    context 'when request is different to the link path' do
      let(:url) { 'http://test.localhost:3000/tags' }

      it 'returns nil' do
        expect(menu_link.add_active_class(view)).to be_nil
      end
    end
  end

  describe "#link_class" do
    context 'when it has a custom class' do
      subject(:menu_link) { described_class.new(custom_class: 'nav-primary__text--logo') }

      it 'returns the default and custom classes' do
        expect(menu_link.link_class).to eq 'nav-primary__text nav-primary__text--logo'
      end
    end

    context 'when it does not have a custom class' do
      subject(:menu_link) { described_class.new }

      it 'returns the default class' do
        expect(menu_link.link_class).to eq 'nav-primary__text'
      end
    end
  end
end
