# frozen_string_literal: true

FactoryBot.define do
  factory :task_assignment do
    task
    employee
    assigned_date { Faker::Date.forward(days: 30) }
  end
end
