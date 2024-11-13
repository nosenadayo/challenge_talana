# frozen_string_literal: true

# Servicio encargado de asignar tareas a empleados de manera eficiente
# Considera habilidades, disponibilidad y balance de carga de trabajo
module TaskAssignments
  class Create
    # Error personalizado para cuando no hay empleados disponibles
    class NoAvailableEmployeesError < StandardError; end

    # Método de clase para facilitar el uso del servicio
    # @param date [Date] fecha para la cual se asignarán las tareas
    # @return [Array<TaskAssignment>] lista de asignaciones creadas
    def self.assign_tasks(date)
      new(date).assign_tasks
    end

    # Inicializa el servicio con la fecha específica y prepara las estructuras necesarias
    # @param date [Date] fecha para la cual se asignarán las tareas
    def initialize(date)
      @date = date
      @assignments = []
      @available_employees = fetch_available_employees
    end

    # Método principal que ejecuta el proceso de asignación
    # @return [Array<TaskAssignment>] lista de asignaciones creadas
    def assign_tasks
      prioritized_tasks.each do |task|
        assign_task(task)
      end
      @assignments
    end

    private

    # Obtiene la lista de empleados disponibles para la fecha especificada
    # Incluye sus habilidades y disponibilidades para optimizar consultas
    # @return [Array<EmployeeAvailability>] lista de empleados disponibles con su información
    def fetch_available_employees
      Employee.joins(:availabilities)
              .where(availabilities: { date: @date })
              .includes(:skills, :availabilities)
              .map { |employee| EmployeeAvailability.new(employee, @date) }
    end

    # Obtiene y prioriza las tareas pendientes para la fecha
    # Las ordena según su puntuación de prioridad (urgencia, complejidad, duración)
    # @return [Array<Task>] lista ordenada de tareas por prioridad
    def prioritized_tasks
      Task.unassigned
          .where(due_date: @date)
          .includes(:skills)
          .sort_by { |task| task_priority_score(task) }
          .reverse
    end

    # Asigna una tarea específica al mejor empleado disponible
    # @param task [Task] tarea a asignar
    # @raise [NoAvailableEmployeesError] si no hay empleados disponibles para la tarea
    def assign_task(task)
      suitable_employees = find_suitable_employees(task)

      if suitable_employees.empty?
        raise NoAvailableEmployeesError,
              "No hay empleados disponibles para la tarea: #{task.title}"
      end

      selected_employee = select_best_employee(suitable_employees, task)
      create_assignment(task, selected_employee)
    end

    # Encuentra empleados que cumplen con los requisitos de la tarea
    # @param task [Task] tarea para la cual se buscan empleados
    # @return [Array<EmployeeAvailability>] lista de empleados que pueden realizar la tarea
    def find_suitable_employees(task)
      required_skills = task.skills.to_set
      required_hours = task.estimated_hours

      @available_employees.select do |employee_availability|
        employee_availability.required_skills?(required_skills) &&
          employee_availability.enough_time?(required_hours)
      end
    end

    # Selecciona el mejor empleado para una tarea específica
    # @param suitable_employees [Array<EmployeeAvailability>] lista de empleados candidatos
    # @param task [Task] tarea a asignar
    # @return [EmployeeAvailability] el mejor empleado para la tarea
    def select_best_employee(suitable_employees, task)
      suitable_employees.max_by { |employee_availability| employee_score(employee_availability, task) }
    end

    # Crea la asignación en la base de datos y actualiza el estado del empleado
    # @param task [Task] tarea a asignar
    # @param employee_availability [EmployeeAvailability] empleado seleccionado
    # @return [TaskAssignment] la asignación creada
    def create_assignment(task, employee_availability)
      assignment = TaskAssignment.create!(
        task: task,
        employee: employee_availability.employee,
        assigned_date: @date
      )

      employee_availability.reduce_available_hours(task.estimated_hours)
      @assignments << assignment
    end

    # Calcula la puntuación de prioridad de una tarea
    # Considera urgencia, complejidad y duración
    # @param task [Task] tarea a evaluar
    # @return [Float] puntuación de prioridad
    def task_priority_score(task)
      [
        urgency_score(task),
        complexity_score(task),
        task.estimated_hours
      ].sum
    end

    # Calcula la puntuación de urgencia basada en la proximidad a la fecha límite
    # @param task [Task] tarea a evaluar
    # @return [Integer] puntuación de urgencia (1-10)
    def urgency_score(task)
      days_until_due = (task.due_date - @date).to_i
      return 10 if days_until_due <= 0  # Máxima urgencia si está vencida o vence hoy
      return 5 if days_until_due <= 2   # Alta urgencia si vence en 2 días
      return 3 if days_until_due <= 5   # Urgencia media si vence en 5 días

      1                                 # Baja urgencia para el resto
    end

    # Calcula la puntuación de complejidad basada en el número de habilidades requeridas
    # @param task [Task] tarea a evaluar
    # @return [Integer] puntuación de complejidad
    def complexity_score(task)
      task.skills.count * 2 # Cada habilidad requerida suma 2 puntos
    end

    # Calcula la puntuación total de un empleado para una tarea específica
    # @param employee_availability [EmployeeAvailability] empleado a evaluar
    # @param task [Task] tarea a asignar
    # @return [Float] puntuación total del empleado
    def employee_score(employee_availability, task)
      [
        skill_match_score(employee_availability, task),
        availability_score(employee_availability, task),
        workload_balance_score(employee_availability)
      ].sum
    end

    # Calcula la puntuación de coincidencia de habilidades
    # Premia tanto las coincidencias exactas como las habilidades adicionales
    # @param employee_availability [EmployeeAvailability] empleado a evaluar
    # @param task [Task] tarea a asignar
    # @return [Float] puntuación de coincidencia de habilidades
    def skill_match_score(employee_availability, task)
      required_skills = task.skills.to_set
      employee_skills = employee_availability.employee.skills.to_set

      exact_matches = (required_skills & employee_skills).size  # Intersección de conjuntos
      extra_skills = (employee_skills - required_skills).size   # Diferencia de conjuntos

      (exact_matches * 3) + (extra_skills * 0.5) # Prioriza coincidencias exactas
    end

    # Calcula la puntuación de disponibilidad basada en la eficiencia del uso del tiempo
    # @param employee_availability [EmployeeAvailability] empleado a evaluar
    # @param task [Task] tarea a asignar
    # @return [Float] puntuación de disponibilidad
    def availability_score(employee_availability, task)
      available_hours = employee_availability.available_hours
      required_hours = task.estimated_hours

      return 0 if available_hours < required_hours

      efficiency_ratio = required_hours / available_hours
      efficiency_ratio * 5 # Premia el uso eficiente del tiempo disponible
    end

    # Calcula la puntuación de balance de carga de trabajo
    # Favorece a empleados con menos tareas asignadas
    # @param employee_availability [EmployeeAvailability] empleado a evaluar
    # @return [Float] puntuación de balance de carga
    def workload_balance_score(employee_availability)
      assignments_count = TaskAssignment.where(
        employee: employee_availability.employee,
        assigned_date: @date
      ).count

      10 / (assignments_count + 1.0) # Puntuación inversa al número de asignaciones
    end
  end
end
