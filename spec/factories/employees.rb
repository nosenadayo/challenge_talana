# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    daily_hours { rand(4.0..8.0).round(2) }

    trait :with_skills do
      after(:create) do |employee|
        create_list(:skill, 2).each do |skill|
          create(:employee_skill, employee: employee, skill: skill)
        end
      end
    end

    trait :with_availability do
      after(:create) do |employee|
        create(:availability, employee: employee)
      end
    end
  end
end
