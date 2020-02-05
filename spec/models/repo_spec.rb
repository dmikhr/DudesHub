require 'rails_helper'

RSpec.describe Repo, type: :model do
  it { should belong_to :user }

  it { should have_db_column(:full_name).of_type(:string) }
  it { should have_db_column(:repo_id).of_type(:integer) }
  it { should have_db_column(:monitored).of_type(:boolean) }

  it { should validate_presence_of :full_name }
  it { should validate_presence_of :repo_id }

  describe "validate_uniqueness_of repo_id" do
    let(:user) { create(:user) }
    let!(:repo) { create(:repo, user: user) }

    it { should validate_uniqueness_of(:repo_id) }
  end

  it { should validate_numericality_of(:repo_id).only_integer }
end
