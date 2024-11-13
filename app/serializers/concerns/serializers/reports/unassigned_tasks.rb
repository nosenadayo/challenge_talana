module Serializers
  module Reports
    module UnassignedTasks
      extend ActiveSupport::Concern

      class_methods do
        def generate_unassigned_tasks(date)
          Task.unassigned
              .where('due_date >= ?', date)
              .map do |task|
            build_unassigned_task_summary(task)
          end
        end

        private

        def build_unassigned_task_summary(task)
          {
            id: task.id,
            title: task.title,
            estimated_hours: task.estimated_hours,
            due_date: task.due_date,
            priority_score: task.priority_score,
            required_skills: task.skills.pluck(:name)
          }
        end
      end
    end
  end
end 