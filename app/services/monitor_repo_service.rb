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
      @pull_request_opened_events = @events.select { |event| event[:type] == "PullRequestEvent" &&
                                                       event[:payload][:action] == "opened" &&
                                                       event[:created_at] > @last_check_time }
    end

    def process_opened_pull_requests
      @pull_request_opened_events.each { |pl_event| DudeJob.perform_now(pl_event[:payload][:pull_request]) }
    end
  end
end
