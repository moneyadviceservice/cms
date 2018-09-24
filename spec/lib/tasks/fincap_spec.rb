require 'rake'

RSpec.describe 'fincap' do
  before :all do
    Rake.application.rake_require 'tasks/fincap'
    Rake::Task.define_task(:environment)
  end

  describe 'fix_evidence_summaries_created_at' do
    subject(:run_task) do
      Rake::Task['fincap:fix_evidence_summaries_created_at'].reenable
      Rake.application.invoke_task 'fincap:fix_evidence_summaries_created_at'
      evidence_summary_page.reload
    end

    let!(:evidence_summary_page) do
      create(:insight_page_with_year_of_publication, year: year_of_publication)
    end

    let!(:initial_creation) { evidence_summary_page.created_at }

    shared_examples 'not updated by the rake task' do
      it 'does not change the creation time' do
        expect { run_task }
          .to_not change { evidence_summary_page.created_at.to_s }
      end
    end

    context 'when the year of publiation is before 2018' do
      let(:year_of_publication) { '2017' }

      it 'sets the creation time to 1st second of the publication year' do
        expect { run_task }
          .to change { evidence_summary_page.created_at }
          .from(initial_creation)
          .to('2017-01-01 00:00:0')
      end
    end

    context 'when the year of publication is 2018' do
      let(:year_of_publication) { '2018' }
      include_examples 'not updated by the rake task'
    end

    context 'when the year of publication is after 2018' do
      let(:year_of_publication) { '2019' }
      include_examples 'not updated by the rake task'
    end

    context 'when the year of publication contains invalid data' do
      let(:year_of_publication) { 'YEAR OF THE DRAGON!' }
      include_examples 'not updated by the rake task'
    end

    context 'when the year of publication is not defined' do
      let(:year_of_publication) { nil }
      include_examples 'not updated by the rake task'
    end

    context 'when the year of publication is empty' do
      let(:year_of_publication) { '' }
      include_examples 'not updated by the rake task'
    end
  end
end
