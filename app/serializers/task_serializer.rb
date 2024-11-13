# frozen_string_literal: true

class TaskSerializer
  include JSONAPI::Serializer

  attributes :title, :due_date, :estimated_hours

  has_many :skills

  attribute :skill_names do |object|
    object.skills.pluck(:name)
  end

  attribute :status do |object|
    object.task_assignments.exists? ? 'assigned' : 'pending'
  end
end
