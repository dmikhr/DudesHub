require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe DudeJob, type: :job do
  let!(:github_service) { GithubService.new }
  let!(:pull_request) { github_service.get_pull_request('dmikhr/test_repo_dude', 2) }

  vcr_options = { :record => :new_episodes }

  it 'perform DudeJob', vcr: vcr_options do
    expect(DudesService).to receive(:call).with(pull_request)
    DudeJob.perform_now(pull_request)
  end
end
