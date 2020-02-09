require 'rails_helper'

RSpec.describe UploadService, type: :service do
  let!(:svg_img) { file_fixture('dudes_diff.svg').read }
  vcr_options = { :record => :new_episodes }

  it '.call UploadService' do
    expect(UploadService).to receive(:call)
    UploadService.call(svg_img, 'test')
  end

  it '.call UploadService real', vcr: vcr_options do
    UploadService.call(svg_img, 'test_real')
  end
end
