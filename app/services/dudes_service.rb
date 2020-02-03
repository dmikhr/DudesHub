require 'securerandom'
# use source code of gems to simplify their code editing (if improvements are needed or bugs are found)
# in the final version of app gems will be used
require_relative "#{Rails.root}/#{Rails.application.credentials[:paths][:dudegl]}"

class DudesService
  class << self
    def call(pull_request = {})
      @pull_request = pull_request
      @params1 = []
      @params2 = []

      diff = DownloadService.call(@pull_request[:diff_url], :read_by_line)
      @diff_data = GitDiffService.call(diff)
      @diff_data.map { |item| process_item(item) }
      renamed = @diff_data.select { |item| item[:status] == :renamed_class }

      return false if params_empty?

      dudes = DudeGl.new [@params1.flatten.compact, @params2.flatten.compact],
                          dudes_per_row_max: 4, renamed: renamed, diff: true
      dudes.render

      @img_url = UploadService.call(dudes.save_to_string, aws_fname)
      post_comment_on_pull_request_page
    end

    private

    def process_item(item)
      processed_code = ProcessCodeService.new(@pull_request, item).call
      @params1 << processed_code.first
      @params2 << processed_code.last
    end

    # generate unique file name
    def aws_fname
      "#{@pull_request[:user][:login]}-pull_id_#{@pull_request[:id]}-#{SecureRandom.hex(8)}"
    end

    def post_comment_on_pull_request_page
      comment = "DudeGL diff analysis: ![](#{@img_url})"
      github_service = GithubService.new
      github_service.create_pull_request_comment(@pull_request[:head][:repo][:full_name],
                                                 @pull_request[:number], comment)
    end

    # if one of params is empty or both
    # it can happen if pull request has no .rb files, or only configs, migrations, etc.
    def params_empty?
      @params1.empty? || @params2.empty?
    end
  end
end
