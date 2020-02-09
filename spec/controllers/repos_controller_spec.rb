require 'rails_helper'

RSpec.describe ReposController, type: :controller do
  let(:user) { create(:user) }
  let(:user_other) { create(:user) }
  let!(:repo) { create(:repo, user: user) }
  let!(:repo_monitored) { create(:repo, monitored: true, user: user) }
  let!(:repo_other) { create(:repo, user: user_other) }
  let!(:repo_monitored_other) { create(:repo, monitored: true, user: user_other) }

  describe 'ReposController' do
    vcr_options = { :record => :new_episodes }

    describe 'User'
      before { sign_in(user) }

      context 'GET #index' do
        before { get :index }

        it 'render #index template' do
          expect(response).to have_http_status(:success)
          expect(response).to render_template :index
        end

        it 'populates an array of repositories' do
          expect(assigns(:repos)).to eq([repo, repo_monitored])
        end

        it "array of repositories doesn't include repositories of other user" do
          expect(assigns(:repos)).to_not include(repo_other)
        end
      end

      context 'GET #monitor' do
        before { get :monitor }

        it 'populates an array of monitored repositories' do
          expect(assigns(:repos)).to eq([repo_monitored])
        end

        it "array of monitored repositories doesn't include repositories of other user" do
          expect(assigns(:repos)).to_not include(repo_monitored_other)
        end
      end

      context 'GET #not_monitor' do
        before { get :not_monitor }

        it 'populates an array of not monitored repositories' do
          get :not_monitor
          expect(assigns(:repos)).to_not include(repo_other)
        end

        it "array of not monitored repositories doesn't include repositories of other user" do
          expect(assigns(:repos)).to_not include(repo_other)
        end
      end

     context 'PATCH #add_to_monitored' do

       it '#add_to_monitored' do
         patch :add_to_monitored, params: { id: repo.id }
         expect do
           repo.reload
         end.to change { repo.monitored }.from(false).to(true)
       end

       it 'cannot #add_to_monitored repo of other user' do
         patch :add_to_monitored, params: { id: repo_other.id }
         expect do
           repo_other.reload
         end.to_not change { repo_other.monitored }
       end

       it 'redirect to monitored repos' do
         patch :add_to_monitored, params: { id: repo.id }
         expect(response).to redirect_to(monitor_repos_path)
       end
     end

     context 'PATCH #remove_from_monitored' do
       before { patch :remove_from_monitored, params: { id: repo_monitored.id } }

       it '#remove_from_monitored' do
         patch :remove_from_monitored, params: { id: repo_monitored.id }
         expect do
           repo_monitored.reload
         end.to change { repo_monitored.monitored }.from(true).to(false)
       end

       it 'cannot #remove_from_monitored repo of other user' do
         patch :remove_from_monitored, params: { id: repo_monitored_other.id }
         expect do
           repo_monitored_other.reload
         end.to_not change { repo_monitored_other.monitored }
       end

       it 'redirect to not monitored repos' do
         patch :remove_from_monitored, params: { id: repo_monitored.id }
         expect(response).to redirect_to(not_monitor_repos_path)
       end
     end

     context 'GET #refresh', vcr: vcr_options do
       before { get :refresh }

       it 'redirects to root path' do
         expect(response).to redirect_to(root_path)
       end
     end
   end

   describe 'Guest' do
     it 'GET #index redirects to login page' do
       get :index
       expect(response).to redirect_to new_user_session_path
     end

     it '#monitor' do
       get :monitor
       expect(response).to redirect_to new_user_session_path
     end

     it '#not_monitor' do
       get :not_monitor
       expect(response).to redirect_to new_user_session_path
     end

     it 'cannot #add_to_monitored' do
       expect do
         patch :add_to_monitored, params: { id: repo.id }
         repo.reload
       end.to_not change { repo.monitored }
     end

     it 'cannot #remove_from_monitored' do
       expect do
         patch :remove_from_monitored, params: { id: repo_monitored.id }
         repo_monitored.reload
       end.to_not change { repo_monitored.monitored }
     end

     it 'cannot #refresh' do
       get :refresh
       expect(response).to redirect_to new_user_session_path
     end
  end
end
