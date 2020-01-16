FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { "github" }
    uid { "123545" }
  end
end
