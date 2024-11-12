# frozen_string_literal: true

FactoryBot.define do
  factory :availability do
    employee
    date { Faker::Date.forward(days: 30) }
    available_hours { rand(1.0..8.0).round(2) }
  end
end
