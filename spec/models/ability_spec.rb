require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:user_other) { create(:user) }

    context 'user repositories' do
      it { should be_able_to :index, create(:repo, user: user) }
      it { should be_able_to :refresh, create(:repo, user: user) }
      it { should be_able_to :monitor, create(:repo, user: user) }
      it { should be_able_to :not_monitor, create(:repo, user: user) }
      it { should be_able_to :add_to_monitored, create(:repo, user: user) }
      it { should be_able_to :remove_from_monitored, create(:repo, user: user) }
    end

    context 'another user repositories' do
      it { should_not be_able_to :index, create(:repo, user: user_other) }
      it { should_not be_able_to :refresh, create(:repo, user: user_other) }
      it { should_not be_able_to :monitor, create(:repo, user: user_other) }
      it { should_not be_able_to :not_monitor, create(:repo, user: user_other) }
      it { should_not be_able_to :add_to_monitored, create(:repo, user: user_other) }
      it { should_not be_able_to :remove_from_monitored, create(:repo, user: user_other) }
    end
  end
end
