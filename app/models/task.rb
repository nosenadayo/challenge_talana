# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :task_skills, dependent: :destroy
  has_many :skills, through: :task_skills
  has_many :task_assignments, dependent: :destroy
  has_many :employees, through: :task_assignments

  validates :title, presence: true
  validates :due_date, presence: true
  validates :estimated_hours, presence: true,
                              numericality: { greater_than: 0 }
end
