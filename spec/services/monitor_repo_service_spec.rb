require 'rails_helper'

RSpec.describe MonitorRepoService do

  it 'MonitorRepoService' do
    expect(MonitorRepoService).to receive(:call)
    MonitorRepoService.call('dmikhr/test_repo_dude', Time.now)
  end
end
