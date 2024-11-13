class TaskAssignmentReportSerializer
  include JSONAPI::Serializer
  include Serializers::Reports::EmployeeSummary
  include Serializers::Reports::UnassignedTasks
  include Serializers::Reports::Statistics

  set_type :assignment_report

  attributes :assigned_date

  attribute :employees_summary do |_object, params|
    generate_employees_summary(params[:assigned_date])
  end

  attribute :unassigned_tasks do |_object, params|
    generate_unassigned_tasks(params[:assigned_date])
  end

  attribute :summary_stats do |_object, params|
    generate_summary_stats(params[:assigned_date])
  end
end 