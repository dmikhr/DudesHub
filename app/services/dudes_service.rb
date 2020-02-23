require 'securerandom'
# use source code of gems to simplify their code editing (if improvements are needed or bugs are found)
# in the final version of app gems will be used
require_relative "#{Rails.root}/#{Rails.application.credentials[Rails.env.to_sym][:paths][:dudegl]}"

class DudesService
  class << self
    def call(pull_request = {})
      @pull_request = pull_request

      diff = DownloadService.call(@pull_request[:diff_url], :read_by_line)
      @diff_data = GitDiffService.call(diff)
      separate_code
      analyze_by_category

      post_comment_on_pull_request_page
    end

    private

    def analyze_by_category
      @comment = "DudeGL diff analysis:<br/><br/>"
      analyze_code(@diff_data_controllers, :controllers) if !@diff_data_controllers.empty?
      analyze_code(@diff_data_models, :models) if !@diff_data_models.empty?
      analyze_code(@diff_data_others, :others) if !@diff_data_others.empty?
    end

    def analyze_code(diff_data, label)
      @params1 = []
      @params2 = []

      diff_data.map { |item| process_item(item) }
      renamed = diff_data.select { |item| item[:status] == :renamed_class }

      return false if params_empty?

      dudes = DudeGl.new [@params1.flatten.compact, @params2.flatten.compact],
                          dudes_per_row_max: 4, renamed: renamed, diff: true
      dudes.render

      img_url = UploadService.call(dudes.save_to_string, aws_fname)
      @comment += "**#{label.to_s.capitalize}:**<br/> ![](#{img_url})<br/>"
    end

    def separate_code
      @diff_data_controllers = []
      @diff_data_models = []
      @diff_data_others = []

      @diff_data.each do |item|
        if item[:old_name]&.start_with?("app/controllers") || item[:new_name]&.start_with?("app/controllers")
          @diff_data_controllers << item
        elsif item[:old_name]&.start_with?("app/models") || item[:new_name]&.start_with?("app/models")
          @diff_data_models << item
        else
          @diff_data_others << item
        end
      end
    end

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
      github_service = GithubService.new
      github_service.create_pull_request_comment(@pull_request[:head][:repo][:full_name],
                                                 @pull_request[:number], @comment)
    end

    # if one of params is empty or both
    # it can happen if pull request has no .rb files, or only configs, migrations, etc.
    def params_empty?
      @params1.empty? || @params2.empty?
    end
  end
end
