require 'rails_helper'

RSpec.describe DudesService, type: :service do
  let!(:github_service) { GithubService.new }
  let!(:pull_request) { github_service.get_pull_request('dmikhr/test_repo_dude', 2) }

  describe 'DudesService' do
    vcr_options = { :record => :new_episodes }

    it '#call', vcr: vcr_options do
      expect(DudesService.call(pull_request)).to_not be false
    end
  end
end
