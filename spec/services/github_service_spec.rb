require 'rails_helper'

RSpec.describe GithubService, type: :service do
  let!(:github_service) { GithubService.new }

  describe 'GithubService' do
    vcr_options = { :record => :new_episodes }

    it 'user repos', vcr: vcr_options do
      expect(github_service.repos.first[:name].class).to be String
      expect(github_service.repos.first[:id].class).to be Integer
    end

    it '#find_repo_by_name', vcr: vcr_options do
      repo = github_service.find_repo_by_name('test_repo_dude')
      expect(repo[:name]).to eq 'test_repo_dude'
      expect(repo[:id].class).to be Integer
    end

    it '#find_repo_by_id', vcr: vcr_options do
      repo = github_service.find_repo_by_id(233369239)
      expect(repo[:name]).to eq 'test_repo_dude'
    end

    it '#get_pull_requests', vcr: vcr_options do
      pull_requests = github_service.get_pull_requests('dmikhr/test_repo_dude')
      expect(pull_requests.first[:id].class).to be Integer
      expect(pull_requests.first[:url].start_with?('https://api.github.com')).to be_truthy
    end

    it '#get_pull_request', vcr: vcr_options do
      # fetch first pull request
      pull_request = github_service.get_pull_request('dmikhr/test_repo_dude', 1)
      expect(pull_request[:id].class).to be Integer
      expect(pull_request[:url].start_with?('https://api.github.com')).to be_truthy
    end

    it '#create_pull_request_comment', vcr: vcr_options do
      comment = github_service.create_pull_request_comment('dmikhr/test_repo_dude', 1, 'some comment')
      expect(comment[:id].class).to be Integer
      expect(comment[:url].start_with?('https://api.github.com')).to be_truthy
    end

    it '#get_diff', vcr: vcr_options do
      pull_requests = github_service.get_pull_request('dmikhr/test_repo_dude', 1)
      expect(github_service.get_diff(pull_requests).class).to be String
    end

    it '#get_repo_events', vcr: vcr_options do
      repo_events = github_service.get_repo_events('dmikhr/test_repo_dude')
      expect(repo_events.first[:id].class).to be String
    end
  end
end
