require 'rails_helper'

RSpec.describe MonitorService do
  describe 'MonitorService' do
    it '.call' do
      expect(MonitorService).to receive(:call)
      MonitorService.call
    end
  end
end
