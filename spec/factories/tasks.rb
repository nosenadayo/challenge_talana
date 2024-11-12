# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { Faker::Job.title }
    due_date { Faker::Date.forward(days: 30) }
    estimated_hours { rand(1.0..8.0).round(2) }
  end
end
