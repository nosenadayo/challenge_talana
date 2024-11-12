# frozen_string_literal: true

class EmployeeSkill < ApplicationRecord
  belongs_to :employee
  belongs_to :skill

  validates :employee_id, uniqueness: { scope: :skill_id }
end
