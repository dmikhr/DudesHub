class DudeJob < ApplicationJob
  queue_as :default

  def perform(pull_request)
    DudesService.call(pull_request)
  end
end
