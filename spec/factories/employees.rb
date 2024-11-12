# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    daily_hours { rand(4.0..8.0).round(2) }
  end
end
