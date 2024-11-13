# frozen_string_literal: true

module Tasks
  class AssignmentWorker
    include Sidekiq::Worker
    sidekiq_options queue: :default, retry: 3

    def perform(date = nil)
      date = Date.parse(date) if date.is_a?(String)
      date ||= Date.tomorrow # Por defecto asigna tareas para mañana

      Rails.logger.info "Iniciando asignación de tareas para: #{date}"

      begin
        assignments = TaskAssignments::Create.assign_tasks(date)
        log_assignments(assignments)
      rescue TaskAssignmentService::NoAvailableEmployeesError => e
        Rails.logger.error "Error en asignación: #{e.message}"
        notify_admin_about_error(e)
      end
    end

    private

    def log_assignments(assignments)
      Rails.logger.info "Asignaciones completadas: #{assignments.count}"
      assignments.each do |assignment|
        Rails.logger.info "Tarea: #{assignment.task.title} -> Empleado: #{assignment.employee.name}"
      end
    end

    def notify_admin_about_error(error)
      # Implementar notificación al admin (email, Slack, etc.)
    end
  end
end
