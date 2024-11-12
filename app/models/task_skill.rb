# frozen_string_literal: true

class TaskSkill < ApplicationRecord
  belongs_to :task
  belongs_to :skill

  validates :task_id, uniqueness: { scope: :skill_id }
end
