RSpec.describe PageRegister do
  let(:user) { FactoryGirl.build(:user) }
  let(:params) { {} }
  subject { described_class.new(page, params: params, current_user: user) }

  describe '#save' do
    before { allow(subject).to receive(:create_revision) }

    describe 'saving the page' do
      context 'user is an editor' do
        let(:user) do
          FactoryGirl.build(:user, role: Comfy::Cms::User.roles[:editor])
        end

        context 'new page' do
          let(:page) { FactoryGirl.build(:page) }

          it 'allows the object to be saved' do
            expect { subject.save }.to raise_error(ActiveRecord::RecordInvalid)
            expect(page.errors.full_messages)
              .to include('Insufficient permissions to change')
          end
        end

        context 'trying to save an "unsaved" existing page' do
          let(:page) { FactoryGirl.create(:page) }
          let(:params) { { state_event: 'create_initial_draft' } }

          it 'updates the page' do
            expect(page).to receive(:update_state!)
            subject.save
          end
        end

        context 'trying to save a new draft of a published page' do
          let(:page) { FactoryGirl.create(:page) }
          let(:params) { { state_event: 'create_new_draft' } }

          it 'updates the page' do
            expect(page).to receive(:update_state!)
            subject.save
          end
        end

        context 'trying to publish an existing page' do
          let(:page) { FactoryGirl.create(:page) }
          let(:params) { { state_event: 'publish_changes' } }

          it 'does not allow the object to be saved' do
            expect { subject.save }.to raise_error(ActiveRecord::RecordInvalid)
            expect(page.errors.full_messages)
              .to include('Insufficient permissions to change')
          end
        end

        context 'trying to unpublish an existing page' do
          let(:page) { FactoryGirl.create(:page) }
          let(:params) { { state_event: 'unpublish' } }

          it 'does not allow the object to be saved' do
            expect { subject.save }.to raise_error(ActiveRecord::RecordInvalid)
            expect(page.errors.full_messages)
              .to include('Insufficient permissions to change')
          end
        end

        context 'trying to schedule an existing page' do
          let(:page) { FactoryGirl.create(:page) }
          let(:params) { { state_event: 'schedule' } }

          it 'updates the page' do
            expect(page).to receive(:update_state!)
            subject.save
          end
        end
      end

      context 'new page record' do
        let(:page) { FactoryGirl.build(:page) }
        let(:params) { {} }

        it 'saves the page' do
          expect(page).to receive(:save!)
          subject.save
        end

        it 'creates a revision' do
          subject.save
          expect(subject).to have_received(:create_revision)
        end
      end

      context 'existing page record with no state_event' do
        let(:page) { FactoryGirl.create(:page) }
        let(:params) { {} }

        it 'saves the page' do
          expect(page).to receive(:save!)
          subject.save
        end

        it 'creates a revision' do
          subject.save
          expect(subject).to have_received(:create_revision)
        end
      end

      context 'existing page record with state_event' do
        let(:page) { FactoryGirl.create(:page) }
        let(:params) { { state_event: 'publish' } }

        it 'does not save the page' do
          expect(page).not_to receive(:save!)
          subject.save
        end

        it 'creates a revision' do
          subject.save
          expect(subject).to have_received(:create_revision)
        end
      end
    end

    describe 'updating page state' do
      context 'new page record' do
        let(:page) { FactoryGirl.build(:page) }

        context 'PageRegister has state_event "create_initial_draft"' do
          let(:params) { { state_event: 'create_initial_draft' } }

          it 'updates the state of the page' do
            expect(page).to receive(:update_state!).with('create_initial_draft')
            subject.save
          end

          it 'creates a revision' do
            subject.save
            expect(subject).to have_received(:create_revision)
          end
        end

        context 'PageRegister has state_event which is not "create_initial_draft"' do
          let(:params) { { state_event: 'publish' } }

          it 'does not update the state of the page' do
            expect(page).not_to receive(:update_state!)
            subject.save
          end

          it 'creates a revision' do
            subject.save
            expect(subject).to have_received(:create_revision)
          end
        end
      end

      context 'existing PUBLISHED page record' do
        let(:page) { FactoryGirl.create(:page) }

        context 'PageRegister has state_event "create_initial_draft"' do
          let(:params) { { state_event: 'create_initial_draft' } }

          it 'updates the state of the page' do
            expect(page).to receive(:update_state!).with('create_initial_draft')
            subject.save
          end

          it 'creates a revision' do
            subject.save
            expect(subject).to have_received(:create_revision)
          end
        end

        context 'PageRegister has state_event which is not "save_draft_changes"' do
          let(:params) { { state_event: 'publish' } }

          it 'updates the state of the page' do
            expect(page).to receive(:update_state!).with('publish')
            subject.save
          end

          it 'creates a revision' do
            subject.save
            expect(subject).to have_received(:create_revision)
          end
        end

        context 'PageRegister has no state_event' do
          let(:params) { {} }

          it 'does not update the state of the page' do
            expect(page).not_to receive(:update_state!)
            subject.save
          end

          it 'creates a revision' do
            subject.save
            expect(subject).to have_received(:create_revision)
          end
        end
      end

    end
  end
end
