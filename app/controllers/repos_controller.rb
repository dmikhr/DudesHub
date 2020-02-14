class ReposController < ApplicationController
  before_action :load_repos, only: :index

  authorize_resource

  def index
    @repos = current_user.repos.where(user: current_user)
  end

  # load/update repos from github to db
  def refresh
    update_user_repos
    redirect_to root_path, notice: "Repositories list was updated"
  end

  def monitor
    @repos = current_user.repos.where(user: current_user, monitored: true)
  end

  def not_monitor
    @repos = current_user.repos.where(user: current_user, monitored: false)
  end

  def add_to_monitored
    current_user.repos.update(id, monitored: true) if Repo.find(id).user == current_user
    redirect_to monitor_repos_path
  end

  def remove_from_monitored
    current_user.repos.update(id, monitored: false) if Repo.find(id).user == current_user
    redirect_to not_monitor_repos_path
  end

  private

  def id
    params.require(:id).to_i
  end

  def repo_id
    Repo.find(id).repo_id
  end

  def get_current_user_repos
    @service = GithubService.new
    @repos = @service.get_user_repos(current_user.nickname)
  end

  def update_user_repos
    get_current_user_repos

    Repo.transaction do
      @repos.each { |repo| update_repository(repo) }
    end
  end

  # if this is a new repository, add it to user repositories
  def update_repository(repo)
    return if current_user.repos.where(repo_id: repo[:id]).any?
    current_user.repos.create!(full_name: repo[:full_name], repo_id: repo[:id], monitored: false)
  end

  def load_repos
    return if current_user.nil?
    return if current_user.repos.size > 0
    # if it's a first login, load user's repos from Github
    update_user_repos
  end
end
