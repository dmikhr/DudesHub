require 'rails_helper'

describe 'Whenever Schedule' do
  before do
    load 'Rakefile'
  end

  it 'makes sure `runner` statements exist' do
    schedule = Whenever::Test::Schedule.new(file: 'config/schedule.rb')
    expect(schedule.jobs[:runner].count).to eq 1
  end
end
