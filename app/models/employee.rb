# frozen_string_literal: true

class Employee < ApplicationRecord
  has_many :employee_skills, dependent: :destroy
  has_many :skills, through: :employee_skills
  has_many :task_assignments, dependent: :destroy
  has_many :tasks, through: :task_assignments
  has_many :availabilities, dependent: :destroy

  validates :name, presence: true
  validates :daily_hours, presence: true,
                          numericality: { greater_than: 0, less_than_or_equal_to: 24 }
end
