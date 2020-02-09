require 'rails_helper'

RSpec.describe ProcessCodeService, type: :service do
  let!(:github_service) { GithubService.new }
  let!(:pull_request) { github_service.get_pull_request('dmikhr/test_repo_dude', 2) }

  let!(:diff) { DownloadService.call(pull_request[:diff_url], :read_by_line) }
  let!(:diff_data) { GitDiffService.call(diff) }

  let!(:renamed_changed_file) { diff_data[0] }
  let!(:changed_file) { diff_data[1] }
  let!(:new_file) { diff_data[2] }
  let!(:deleted_file) { diff_data[3] }
  let!(:renamed_file) { diff_data[4] }

  describe 'ProcessCodeService' do
    vcr_options = { :record => :new_episodes }

    it '.call on renamed and changed file', vcr: vcr_options do
      params1, params2 = ProcessCodeService.new(pull_request, renamed_changed_file).call

      expect(params1.class).to be Hash
      expect(params2.class).to be Hash

      expect(params1).to have_key(:name)
      expect(params2).to have_key(:name)

      expect(params1[:methods].class).to be Array
      expect(params2[:methods].class).to be Array

      expect(params1[:methods].first.class).to be Hash
      expect(params2[:methods].first.class).to be Hash
    end

    it '.call on changed file', vcr: vcr_options do
      params1, params2 = ProcessCodeService.new(pull_request, changed_file).call

      expect(params1.class).to be Hash
      expect(params2.class).to be Hash

      expect(params1).to have_key(:name)
      expect(params2).to have_key(:name)

      expect(params1[:methods].class).to be Array
      expect(params2[:methods].class).to be Array

      expect(params1[:methods].first.class).to be Hash
      expect(params2[:methods].first.class).to be Hash
    end

    it '.call on a new file', vcr: vcr_options do
      params1, params2 = ProcessCodeService.new(pull_request, new_file).call

      expect(params1).to be_nil

      expect(params2.class).to be Hash
      expect(params2).to have_key(:name)
      expect(params2[:methods].class).to be Array
      expect(params2[:methods].first.class).to be Hash
    end

    it '.call on deleted file', vcr: vcr_options do
      params1, params2 = ProcessCodeService.new(pull_request, deleted_file).call

      expect(params2).to be_nil

      expect(params1.class).to be Hash
      expect(params1).to have_key(:name)
      expect(params1[:methods].class).to be Array
      expect(params1[:methods].first.class).to be Hash
    end

    it '.call on renamed file', vcr: vcr_options do
      params1, params2 = ProcessCodeService.new(pull_request, renamed_file).call

      expect(params1.class).to be Hash
      expect(params2.class).to be Hash

      expect(params1).to have_key(:name)
      expect(params2).to have_key(:name)

      expect(params1[:methods].class).to be Array
      expect(params2[:methods].class).to be Array

      expect(params1[:methods].first.class).to be Hash
      expect(params2[:methods].first.class).to be Hash
    end
  end
end
