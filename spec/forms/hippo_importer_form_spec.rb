RSpec.describe HippoImporterForm do
  subject(:form) { described_class.new }

  describe 'validations' do
    context 'hippo_file' do
      it { expect(form).to have_valid(:hippo_file).when('a file') }

      it { expect(form).to_not have_valid(:hippo_file).when('', nil) }
    end

    context 'slugs' do
      it { expect(form).to have_valid(:slugs).when(['about-borrow']) }

      it { expect(form).to_not have_valid(:slugs).when('', nil) }
    end

    context 'site' do
      it { expect(form).to have_valid(:site).when('en', 'cy') }

      it { expect(form).to_not have_valid(:site).when('', nil, 'inexistent') }
    end

    context 'migration_type' do
      it { expect(form).to have_valid(:migration_type).when('article', 'corporate_page', 'about_us', nil, '') }

      it { expect(form).to_not have_valid(:migration_type).when('inexistent-type') }
    end
  end
end
