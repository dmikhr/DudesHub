# docs: https://octokit.github.io/octokit.rb/Octokit/Client/Gists.html
# https://octokit.github.io/octokit.rb/Octokit/Client/PullRequests.html

class GithubService
  attr_reader :repos

  def initialize
    @client = octokit_client
    @repos = @client.repositories(user_login)
  end

  def find_repo_by_name(name)
    # potentially useful keys: :full_name, :id, :private, [:owner][:login], :description, :html_url
    repo = @repos.select { |repo| repo[:name] == name }
    repo.first unless repo.empty?
  end

  def find_repo_by_id(id)
    # potentially useful keys: :full_name, :id, :private, [:owner][:login], :description, :html_url
    repo = @repos.select { |repo| repo[:id] == id }
    repo.first unless repo.empty?
  end

  # get a list of open pull request for a given repo
  # https://octokit.github.io/octokit.rb/Octokit/Client/PullRequests.html#pull_requests-instance_method
  def get_pull_requests(repo_full_name)
    @client.pull_requests(repo_full_name, state: 'open')
  end

  # https://octokit.github.io/octokit.rb/Octokit/Client/PullRequests.html#pull_request-instance_method
  # Octokit.pull_request('rails/rails', 42, :state => 'closed')
  # :url, :id, :state, :number, :title
  def get_pull_request(repo_full_name, pull_request_id)
    @client.pull_request(repo_full_name, pull_request_id)
  end

  # https://www.rubydoc.info/gems/octokit/Octokit/Client/Events#repository_events-instance_method
  def get_repo_events(repo_full_name)
    @client.repository_events(repo_full_name)
  end

  # https://developer.github.com/v3/guides/working-with-comments/
  # https://developer.github.com/v3/issues/comments/#create-a-comment
  # https://octokit.github.io/octokit.rb/Octokit/Client/Issues.html#add_comment-instance_method
  def create_pull_request_comment(repo_full_name, pull_request_id, comment)
    # comment = 'https://camo.githubusercontent.com/097ad4338d515251c51ef24d9416e554c469b8b9/687474703a2f2f6b6872616d74736f762e6e65742f66696c65732f64756465735f646966662e7376673f73616e6974697a653d74727565'

    # Issue comments in pull request https://stackoverflow.com/questions/16744069/create-comment-on-pull-request
    pull_request = get_pull_request(repo_full_name, pull_request_id)

    comments_url = pull_request[:_links][:comments]
    # sample comments_url: https://api.github.com/repos/dmikhr/test_repo_dude/issues/1/comments
    pull_request_issue_id = comments_url[:href].split('/')[-2]

    @client.add_comment(repo_full_name, pull_request_issue_id, comment)
  end

  def get_diff(pull_request)
    # https://github.com/dmikhr/test_repo_dude/pull/1.diff
    diff_url = pull_request[:diff_url]
    DownloadService.call(diff_url)
  end

  def user_login
    @client.user[:login]
  end

  private

  def octokit_client
    client = Octokit::Client.new(access_token: access_token)
  end

  def access_token
    Rails.application.credentials[Rails.env.to_sym][:github][:access_token]
  end
end
