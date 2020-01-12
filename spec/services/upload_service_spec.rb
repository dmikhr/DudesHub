require 'rails_helper'

RSpec.describe UploadService, type: :service do
  let(:data_string) { File.open(Rails.application.credentials[:test_file_path], "rb").read }
  let(:upload_service) { UploadService.new(data_string) }

  it 'call UploadService' do
    expect(upload_service).to receive(:call)
    upload_service.call
  end
end
