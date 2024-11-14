# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { Faker::Job.title }
    due_date { 1.week.from_now }
    estimated_hours { rand(1.0..8.0).round(2) }

    # Aseguramos que siempre tenga al menos una habilidad
    after(:build) do |task|
      task.skills << create(:skill) if task.skills.empty?
    end

    trait :with_assignments do
      after(:create) do |task|
        create(:task_assignment, task: task)
      end
    end

    trait :overdue do
      # Para tests que específicamente necesitan tareas vencidas
      to_create { |instance| instance.save(validate: false) }
      due_date { 1.week.ago }
    end

    trait :urgent do
      due_date { 1.day.from_now }
      estimated_hours { 8 }
    end

    trait :future do
      due_date { 2.weeks.from_now }
      estimated_hours { 4 }
    end
  end
end
