# frozen_string_literal: true

module Serializers
  module Reports
    module EmployeeSummary
      extend ActiveSupport::Concern

      class_methods do
        def generate_employees_summary(date)
          Employee.includes(:task_assignments, :skills)
                  .where(task_assignments: { assigned_date: date })
                  .map do |employee|
            build_employee_summary(employee, date)
          end
        end

        private

        def build_employee_summary(employee, date)
          {
            id: employee.id,
            name: employee.name,
            assignments: build_assignments_summary(employee, date),
            total_hours: calculate_total_hours_summary(employee, date),
            available_hours: calculate_available_hours(employee, date),
            skills: employee.skills.pluck(:name)
          }
        end

        def build_assignments_summary(employee, date)
          employee.task_assignments
                  .where(assigned_date: date)
                  .map { |assignment| task_summary(assignment) }
        end

        def task_summary(assignment)
          {
            id: assignment.task.id,
            title: assignment.task.title,
            estimated_hours: assignment.task.estimated_hours,
            priority_score: assignment.task.priority_score,
            required_skills: assignment.task.skills.pluck(:name)
          }
        end

        def calculate_total_hours_summary(employee, date)
          employee.task_assignments
                  .where(assigned_date: date)
                  .joins(:task)
                  .sum('tasks.estimated_hours')
        end

        def calculate_available_hours(employee, date)
          8 - calculate_total_hours_summary(employee, date)
        end
      end
    end
  end
end
