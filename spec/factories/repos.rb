require 'securerandom'

FactoryBot.define do
  sequence :full_name do |n|
    "user/repo_#{SecureRandom.hex(4)}"
  end
  sequence :repo_id do |n|
    "#{SecureRandom.random_number(100000)}#{n}".to_i
  end
  factory :repo do
    full_name
    repo_id
    monitored { false }
  end
end
