RSpec.describe PagesController do
  let(:site) { create(:site) }
  let(:layout) { create(:layout) }
  let(:role) { :user }
  let(:current_user) { create(:user, role: Comfy::Cms::User.roles[role]) }
  let(:last_revision) { assigns[:page].revisions.last }

  before do
    sign_in current_user
  end

  describe 'POST create' do
    let(:label) { Faker::Lorem.sentence }
    let(:slug) { Faker::Internet.slug(label, '-') }
    let(:content) { Faker::Lorem.sentence }

    let(:params) do
      {
        site_id: site,
        page: {
          label: label,
          slug: slug,
          layout_id: layout
        },
        blocks_attributes: [
          {
            identifier: 'content',
            content: content
          }
        ]
      }
    end

    context 'when it fails the permisson check' do
      before { allow_any_instance_of(PermissionCheck).to receive(:fail?) { true } }

      it 'redirects to the page index' do
        post :create, params
        expect(response).to redirect_to(comfy_admin_cms_site_pages_path(site))
      end

      it "shows a flash message saying you don't have sufficient permissions" do
        post :create, params
        expect(flash[:danger]).to eq 'Insufficient permissions to change'
      end
    end

    context 'when it passes the permission check' do
      before { allow_any_instance_of(PermissionCheck).to receive(:fail?) { false } }

      context 'and it saves successfully' do
        it "redirects to the article's main content edit page" do
          post :create, params
          page = Comfy::Cms::Page.order('id ASC').last
          expect(response).to redirect_to(edit_comfy_admin_cms_site_page_path(site, page))
        end
      end

      context 'and it does not save successfully' do
        let(:layout) { nil }

        it 're-renders the edit template' do
          post :create, params
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'PUT update' do
    let(:original_content) { Faker::Lorem.sentence }
    let(:state) { 'published' }
    let(:page) { create(:page, site: site, state: state) }
    let!(:block) { create(:block, blockable: page, content: original_content) }

    let(:params) do
      {
        site_id: site,
        id: page,
        blocks_attributes: [
          {
            identifier: 'content',
            content: Faker::Lorem.sentence
          }
        ]
      }
    end

    before { ActionMailer::Base.deliveries.clear }

    context 'when it fails the permisson check' do
      before { allow_any_instance_of(PermissionCheck).to receive(:fail?) { true } }

      it 'redirects to the page index' do
        put :update, params
        expect(response).to redirect_to(comfy_admin_cms_site_pages_path(site))
      end

      it "shows a flash message saying you don't have sufficient permissions" do
        put :update, params
        expect(flash[:danger]).to eq 'Insufficient permissions to change'
      end
    end

    context 'when it passes the permission check' do
      before { allow_any_instance_of(PermissionCheck).to receive(:fail?) { false } }

      context 'if we are updating main content' do
        before { allow(controller).to receive(:updating_alternate_content?) { false } }

        context 'and it saves successfully' do
          it "redirects to the article's main content edit page" do
            put :update, params
            expect(response).to redirect_to(edit_comfy_admin_cms_site_page_path(site, page))
          end
        end
      end

      context 'if we are updating alternate content' do
        # Just need to be in an appropriate state to update alternate content. Strictly speaking
        # the page should have an active_revision but we can make do without in this situation.
        let(:state) { 'published_being_edited' }

        before { allow(controller).to receive(:updating_alternate_content?) { true } }

        context 'and the page actually has alternate content' do
          before { allow_any_instance_of(AlternatePageBlocksRetriever).to receive(:blocks_attributes) { double } }

          context 'and it saves successfully' do
            it "redirects to the article's alternate content edit page" do
              put :update, params.merge(alternate: true)
              expect(response).to redirect_to(edit_comfy_admin_cms_site_page_path(site, page, alternate: true))
            end

            context 'when the user is an editor' do
              let(:role) { :editor }

              it 'sends a notification email' do
                put :update, params.merge(alternate: true)
                expect(ActionMailer::Base.deliveries.last.subject).to include('Content updated by External Editor')
              end
            end
          end

          context 'and it does not save successfully' do
            before { put :update, params.merge(alternate: true, page: { layout_id: '' }) }

            it 're-renders the edit template' do
              expect(response).to render_template(:edit)
            end

            context 'when the user is an editor' do
              let(:role) { :editor }

              it 'does not send a notification email' do
                expect(ActionMailer::Base.deliveries).to be_empty
              end
            end
          end
        end

        context 'but the page does not have alternate content' do
          before { allow_any_instance_of(AlternatePageBlocksRetriever).to receive(:blocks_attributes) { nil } }

          it "redirects to the article's main content edit page" do
            put :update, params.merge(alternate: true)
            expect(response).to redirect_to(edit_comfy_admin_cms_site_page_path(site, page))
          end

          it "shows a flash message saying alternate content isn't available for this page" do
            put :update, params.merge(alternate: true)
            expect(flash[:danger]).to eq 'Alternate content is not currently available for this page'
          end
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:original_content) { Faker::Lorem.sentence }
    let(:state) { 'published' }
    let(:page) { create(:page, site: site, state: state) }
    let!(:block) { create(:block, blockable: page, content: original_content) }

    let(:params) do
      {
        site_id: site,
        id: page
      }
    end

    before { ActionMailer::Base.deliveries.clear }

    context 'when it fails the permisson check' do
      before { allow_any_instance_of(PermissionCheck).to receive(:fail?) { true } }

      it 'redirects to the page index' do
        delete :destroy, params
        expect(response).to redirect_to(comfy_admin_cms_site_pages_path(site))
      end

      it "shows a flash message saying you don't have sufficient permissions" do
        delete :destroy, params
        expect(flash[:danger]).to eq 'Insufficient permissions to change'
      end
    end

    context 'when it passes the permission check' do
      before { allow_any_instance_of(PermissionCheck).to receive(:fail?) { false } }

      context 'if we are updating main content' do
        before { allow(controller).to receive(:updating_alternate_content?) { false } }

        context 'and it saves successfully' do
          it "redirects to the article's main content edit page" do
            delete :destroy, params
            expect(response).to redirect_to(edit_comfy_admin_cms_site_page_path(site, page))
          end
        end
      end

      context 'if we are deleting alternate content' do
        before { allow(controller).to receive(:updating_alternate_content?) { true } }

        context 'and the page actually has alternate content' do
          before { allow_any_instance_of(AlternatePageBlocksRetriever).to receive(:blocks_attributes) { double } }

          it "redirects to the article's main content edit page" do
            delete :destroy, params.merge(alternate: true)
            expect(response).to redirect_to(edit_comfy_admin_cms_site_page_path(site, page))
          end
        end

        context 'but the page does not have alternate content' do
          before { allow_any_instance_of(AlternatePageBlocksRetriever).to receive(:blocks_attributes) { nil } }

          it "redirects to the article's main content edit page" do
            delete :destroy, params.merge(alternate: true)
            expect(response).to redirect_to(edit_comfy_admin_cms_site_page_path(site, page))
          end

          it "shows a flash message saying alternate content isn't available for this page" do
            delete :destroy, params.merge(alternate: true)
            expect(flash[:danger]).to eq 'Alternate content is not currently available for this page'
          end
        end
      end
    end
  end

  describe '#updating_alternate_content?' do
    let(:page) { create(:page, state: state) }

    before { controller.instance_variable_set(:@page, page) }

    subject { controller.send(:updating_alternate_content?) }

    context 'when the page is "unsaved"' do
      let(:state) { 'unsaved' }

      it { should be false }
    end

    context 'when the page is "draft"' do
      let(:state) { 'draft' }

      it { should be false }
    end

    context 'when the page is "published"' do
      let(:state) { 'published' }

      it { should be false }
    end

    context 'when the page is "published_being_edited"' do
      let(:state) { 'published_being_edited' }

      context 'and the "alternate" param is not set' do
        it { should be false }

        context 'but we have just transitioned from "published"' do
          before { controller.params[:state_event] = 'create_new_draft' }

          it { should be true }
        end
      end

      context 'and the "alternate" param is set' do
        before { controller.params[:alternate] = true }

        it { should be true }
      end
    end

    context 'when the page is "scheduled"' do
      let(:state) { 'scheduled' }

      it { should be false }

      context 'and the "alternate" param is not set' do
        it { should be false }

        context 'but we have just transitioned from a draft state' do
          before { controller.params[:state_event] = 'schedule' }

          context 'and this is a scheduled update to a live article' do
            let(:revision) { create(:revision, record: page) }
            before { page.update_column(:active_revision_id, revision.id) }

            it { should be false }
          end
        end
      end

      context 'and the "alternate" param is set' do
        before { controller.params[:alternate] = true }

        context 'and this article live article' do
          let(:revision) { create(:revision, record: page) }
          before { page.update_column(:active_revision_id, revision.id) }

          it { should be true }
        end
      end
    end
  end
end
