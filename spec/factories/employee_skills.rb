# frozen_string_literal: true

FactoryBot.define do
  factory :employee_skill do
    employee
    skill
  end
end
