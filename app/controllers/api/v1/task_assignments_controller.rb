module Api
  module V1
    class TaskAssignmentsController < BaseController
      def report
        date = parse_date
        assignments = TaskAssignment.includes(:task, :employee)
                                  .where(assigned_date: date)
                                  .order('employees.name')

        render json: TaskAssignmentReportSerializer.new(
          assignments,
          params: { assigned_date: date }
        ).serializable_hash
      end

      private

      def parse_date
        Date.parse(params[:date])
      rescue TypeError, Date::Error
        Date.today
      end
    end
  end
end
