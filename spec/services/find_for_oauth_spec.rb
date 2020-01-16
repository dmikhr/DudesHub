require 'rails_helper'

RSpec.describe FindForOauth, type: :service do
  let!(:user) { create(:user) }
  let(:auth) { mock_auth(:github, user.email) }
  let(:user_auth) { create(:authorization, user: user) }
  subject { FindForOauth.new }

  context 'user already has authorization' do
    it 'returns the user' do
      user_auth
      expect(subject.call(auth)).to eq user
    end
  end

  context 'user has not authorization' do
    context 'user already exists' do
      let(:auth) { mock_auth(:github, user.email) }

      it 'does not create new user' do
        expect {subject.call(auth)}.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect {subject.call(auth)}.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject.call(auth)).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { mock_auth(:github, 'new@user.com') }

      it 'creates new user' do
        expect {subject.call(auth)}.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call(auth)).to be_a(User)
      end

      it 'fills user email' do
        user = subject.call(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization for user' do
        user = subject.call(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
