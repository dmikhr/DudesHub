require 'rails_helper'

RSpec.describe GitDiffService, type: :service do
  let!(:diff) { file_fixture('diff_sample.txt').readlines }
  let(:git_diff_service) { GitDiffService.new(diff) }

  describe 'GitDiffService' do
    vcr_options = { :record => :new_episodes }

    it '#call', vcr: vcr_options do
      expect(git_diff_service.call.class).to be Array
      expect(git_diff_service.call).to_not be_empty

      expect(git_diff_service.call.first.class).to be Hash
      expect(git_diff_service.call.first.keys.sort).to be == %i[old_name new_name status].sort
    end

    it '#renamed', vcr: vcr_options do
      git_diff_service.call
      expect(git_diff_service.renamed_files.class).to be Array
      expect(git_diff_service.renamed_files).to_not be_empty

      expect(git_diff_service.renamed_files.first.class).to be Hash
      expect(git_diff_service.renamed_files.first.keys.sort).to be == %i[old_name new_name status].sort

      expect(git_diff_service.renamed_files.first[:status]).to be :renamed
    end
  end
end
