# frozen_string_literal: true

FactoryBot.define do
  factory :availability do
    employee
    date { Time.zone.today }
    available_hours { rand(4.0..8.0).round(2) }

    trait :future do
      date { rand(1..30).days.from_now }
    end

    trait :past do
      date { rand(1..30).days.ago }
    end
  end
end
