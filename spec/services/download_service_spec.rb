require 'rails_helper'

RSpec.describe DownloadService, type: :service do
  let(:url) { 'https://github.com/dmikhr/test_repo_dude/pull/1.diff' }

  describe 'DownloadService' do
    vcr_options = { :record => :new_episodes }

    it '.call', vcr: vcr_options do
      expect(DownloadService.call(url).class).to be String
    end
  end
end
