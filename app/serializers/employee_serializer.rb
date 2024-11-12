# frozen_string_literal: true

class EmployeeSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :daily_hours do |object|
    object.daily_hours.to_f
  end

  attribute :skill_names do |object|
    object.skills.pluck(:name)
  end

  attribute :total_assignments do |object|
    object.task_assignments.count
  end

  has_many :skills
  has_many :availabilities
end
