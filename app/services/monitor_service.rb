class MonitorService
  class << self
    def call
      User.find_each { |user| monitor_repos(user) }
    end

    private

    def monitor_repos(user)
      Repo.where(user: user, monitored: true).each do |repo|
        MonitorRepoService.call(repo.full_name, repo.updated_at)
        # update updated_at timestamp
        repo.update(updated_at: Time.zone.now)
        repo.reload
      end
    end
  end
end
