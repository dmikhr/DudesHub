require 'rails_helper'

RSpec.describe GitDiffService, type: :service do
  let!(:diff) { file_fixture('diff_sample.txt').readlines }

  describe 'GitDiffService' do
    vcr_options = { :record => :new_episodes }

    it '#call', vcr: vcr_options do
      expect(GitDiffService.call(diff).class).to be Array
      expect(GitDiffService.call(diff)).to_not be_empty

      expect(GitDiffService.call(diff).first.class).to be Hash
      expect(GitDiffService.call(diff).first.keys.sort).to be == %i[old_name new_name status].sort
    end
  end
end
