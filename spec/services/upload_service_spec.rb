require 'rails_helper'

RSpec.describe UploadService, type: :service do
  let(:data_string) { File.open(Rails.application.credentials[:test_file_path], "rb").read }

  it '.call UploadService' do
    expect(UploadService).to receive(:call)
    UploadService.call(data_string, 'test.svg')
  end
end
