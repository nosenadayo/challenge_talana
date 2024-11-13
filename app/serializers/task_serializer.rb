# frozen_string_literal: true

class TaskSerializer
  include JSONAPI::Serializer

  attributes :title, :estimated_hours, :due_date, :status, :skill_names

  has_many :skills

  attribute :estimated_hours do |object|
    object.estimated_hours.to_f
  end

  attribute :due_date do |object|
    object.due_date.to_s
  end

  attribute :priority_score do |object|
    object.priority_score.to_f
  end

  attribute :status do |object|
    object.assigned? ? 'assigned' : 'pending'
  end

  attribute :skill_names do |object|
    object.skills.pluck(:name)
  end
end
