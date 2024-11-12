# frozen_string_literal: true

class SkillSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :employee_count do |object|
    object.employees.count
  end

  attribute :task_count do |object|
    object.tasks.count
  end
end
