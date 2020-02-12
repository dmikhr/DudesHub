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
        Repo.update(full_name: repo.full_name)
      end
    end
  end
end
