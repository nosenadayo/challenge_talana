# frozen_string_literal: true

module Tasks
  class ScheduleAssignment
    include Interactor

    def call
      return unless should_evaluate_assignment?

      ::Tasks::AssignmentWorker.perform_async(
        context.task.due_date.to_s
      )
    end

    private

    def should_evaluate_assignment?
      context.task.due_date.between?(Date.tomorrow, 1.week.from_now) &&
        context.task.priority_score > 150
    end
  end
end
