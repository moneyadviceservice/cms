# Only editors are subject to restriction. They can:
# - save a new page to draft (create_initial_draft event)
# - update pages in draft state
# - create a new draft from a published page (create_new_draft event)
# - update pages in published_being_edited state
# - update pages in scheduled state that are not live yet (published_on is in the future)
RSpec.describe PermissionCheck do
  describe '#pass?' do
    let(:user) { double(editor?: is_editor) }
    let(:state) { nil }
    let(:page) { double(state: state) }
    let(:event) { nil }

    let(:permission_check) { PermissionCheck.new(user, page, action, event) }
    subject { permission_check.pass? }

    context 'when a role other than editor' do
      let(:is_editor) { false }

      context 'with any action' do
        let(:action) { double }

        it 'returns true regardless of event' do
          expect(subject).to be true
        end
      end
    end

    context 'when an editor' do
      let(:is_editor) { true }

      context 'and the action is show' do
        let(:action) { 'show' }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'and the action is index' do
        let(:action) { 'index' }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'and the action is new' do
        let(:action) { 'new' }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'and the action is create' do
        let(:action) { 'create' }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'and the action is edit' do
        let(:action) { 'edit' }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'and the action is update' do
        let(:action) { 'update' }

        context 'and the event is' do
          context '"create_initial_draft"' do
            let(:event) { 'create_initial_draft' }

            it 'returns true' do
              expect(subject).to be true
            end
          end

          context '"create_new_draft"' do
            let(:event) { 'create_new_draft' }

            it 'returns true' do
              expect(subject).to be true
            end
          end

          context 'anything else' do
            let(:event) { 'an_event_with_any_name' }

            it 'returns false' do
              expect(subject).to be false
            end
          end
        end

        context 'and there is no event (just saving changes)' do
          context 'and the page state is "draft"' do
            let(:state) { 'draft' }

            it 'returns true' do
              expect(subject).to be true
            end
          end

          context 'and the page state is "published_being_edited"' do
            let(:state) { 'published_being_edited' }

            it 'returns true' do
              expect(subject).to be true
            end
          end

          context 'and the page state is "scheduled"' do
            let(:state) { 'scheduled' }

            context 'but is not live' do
              before { allow(page).to receive(:scheduled_on) { 1.minute.from_now } }

              it 'returns true' do
                expect(subject).to be true
              end
            end

            context 'and is live' do
              before { allow(page).to receive(:scheduled_on) { 1.minute.ago } }

              it 'returns false' do
                expect(subject).to be false
              end
            end
          end

          context 'and the page state is anything else' do
            let(:state) { 'a_state_with_any_name' }

            it 'returns false' do
              expect(subject).to be false
            end
          end
        end
      end

      context 'and the action is destroy' do
        let(:action) { 'destroy' }

        it 'returns false' do
          expect(subject).to be false
        end
      end
    end
  end
end
