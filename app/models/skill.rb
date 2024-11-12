# frozen_string_literal: true

class Skill < ApplicationRecord
  has_many :employee_skills, dependent: :destroy
  has_many :employees, through: :employee_skills
  has_many :task_skills, dependent: :destroy
  has_many :tasks, through: :task_skills

  validates :name, presence: true, uniqueness: true
end
