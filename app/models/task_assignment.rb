# frozen_string_literal: true

class TaskAssignment < ApplicationRecord
  belongs_to :task
  belongs_to :employee

  validates :task_id, uniqueness: { scope: :assigned_date }
end
