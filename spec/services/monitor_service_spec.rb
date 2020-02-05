require 'rails_helper'

RSpec.describe MonitorService do

  it 'MonitorService' do
    expect(MonitorService).to receive(:call)
    MonitorService.call
  end
end
