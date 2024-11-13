# frozen_string_literal: true

# Clase auxiliar para manejar la disponibilidad de un empleado en una fecha específica
# Encapsula la lógica de verificación de disponibilidad y gestión de horas
class EmployeeAvailability
  attr_reader :employee, :available_hours

  # Inicializa la disponibilidad de un empleado para una fecha
  # @param employee [Employee] el empleado
  # @param date [Date] la fecha a evaluar
  def initialize(employee, date)
    @employee = employee
    @date = date
    @available_hours = fetch_available_hours
  end

  # Verifica si el empleado tiene todas las habilidades requeridas
  # @param required_skills [Set<Skill>] conjunto de habilidades requeridas
  # @return [Boolean] true si tiene todas las habilidades necesarias
  def required_skills?(required_skills)
    (required_skills - @employee.skills.to_set).empty?
  end

  # Verifica si el empleado tiene suficiente tiempo disponible
  # @param required_hours [Float] horas requeridas para la tarea
  # @return [Boolean] true si tiene suficientes horas disponibles
  def enough_time?(required_hours)
    @available_hours >= required_hours
  end

  # Reduce las horas disponibles después de asignar una tarea
  # @param hours [Float] horas a reducir
  def reduce_available_hours(hours)
    @available_hours -= hours
  end

  private

  # Obtiene las horas disponibles del empleado para la fecha específica
  # @return [Float] horas disponibles (0 si no hay disponibilidad registrada)
  def fetch_available_hours
    @employee.availabilities.find_by(date: @date)&.available_hours || 0
  end
end
