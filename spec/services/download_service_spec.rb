require 'rails_helper'

RSpec.describe DownloadService, type: :service do
  let(:url) { 'https://github.com/dmikhr/test_repo_dude/pull/1.diff' }

  describe 'DownloadService' do
    vcr_options = { :record => :new_episodes }

    it '.call default', vcr: vcr_options do
      expect(DownloadService.call(url).class).to be String
    end

    it '.call read_by_line', vcr: vcr_options do
      expect(DownloadService.call(url, :read_by_line).class).to be Array
      expect(DownloadService.call(url, :read_by_line)).to_not be_empty
      expect(DownloadService.call(url, :read_by_line).first.class).to be String
    end
  end
end
