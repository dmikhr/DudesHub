class PanelsController < ApplicationController
  def index
    service = GithubService.new
    @login = service.user_login
    @repos = service.get_user_repos(@login)
  end
end
