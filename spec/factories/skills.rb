# frozen_string_literal: true

FactoryBot.define do
  factory :skill do
    sequence(:name) { |n| "#{Faker::Job.key_skill}_#{n}" }
  end
end
