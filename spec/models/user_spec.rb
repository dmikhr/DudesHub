require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:repos).dependent(:destroy) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).and_return(service)
      expect(service).to receive(:call).with(auth)
      User.find_for_oauth(auth)
    end
  end
end
