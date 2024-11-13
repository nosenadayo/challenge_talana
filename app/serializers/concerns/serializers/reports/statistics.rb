module Serializers
  module Reports
    module Statistics
      extend ActiveSupport::Concern

      class_methods do
        def generate_summary_stats(date)
          {
            total_assignments: count_total_assignments(date),
            total_hours_assigned: calculate_total_hours(date),
            total_employees_assigned: count_assigned_employees(date),
            average_hours_per_employee: calculate_average_hours(date)
          }
        end

        private

        def count_total_assignments(date)
          TaskAssignment.where(assigned_date: date).count
        end

        def calculate_total_hours(date)
          TaskAssignment.where(assigned_date: date)
                       .joins(:task)
                       .sum('tasks.estimated_hours')
        end

        def count_assigned_employees(date)
          Employee.joins(:task_assignments)
                 .where(task_assignments: { assigned_date: date })
                 .distinct
                 .count
        end

        def calculate_average_hours(date)
          total_hours = calculate_total_hours(date)
          total_employees = Employee.count
          return 0 if total_employees.zero?

          (total_hours / total_employees.to_f).round(2)
        end
      end
    end
  end
end 