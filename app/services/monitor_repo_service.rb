class MonitorRepoService
  class << self
    def call(repo_full_name, last_check_time)
      @repo_full_name = repo_full_name
      @last_check_time = last_check_time

      get_repo_events
      get_newly_opened_pull_requests
      process_opened_pull_requests
    end

    private

    def get_repo_events
      github_service = GithubService.new
      @events = github_service.get_repo_events(@repo_full_name)
    end

    def get_newly_opened_pull_requests
      @pull_requests_opened = @events.select { |event| event[:type] == "PullRequestEvent" &&
                                                       event[:payload][:action] == "opened" &&
                                                       event[:created_at] > @last_check_time }
    end

    def process_opened_pull_requests
      @pull_requests_opened.each { |pull_request| DudeJob.perform_now(pull_request) }
    end
  end
end
