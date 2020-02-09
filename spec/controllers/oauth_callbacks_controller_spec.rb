require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'Github' do
    before { @request.env['omniauth.auth'] = mock_auth_github('new@user.com') }

    let(:oauth_data) { mock_auth_github('new@user.com') }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end

    context 'has no user email' do
      before { @request.env['omniauth.auth'] = mock_auth_github(email: nil) }

      it 'redirects to submit email form' do
        get :github
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
