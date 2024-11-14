
# Método para crear o actualizar registros de forma idempotente
def find_or_create_by_name(model, name, attributes = {})
  model.find_or_create_by!(name: name) do |record|
    attributes.each { |key, value| record[key] = value }
  end
end

puts 'Iniciando seed de datos...'

# Creación de habilidades
puts 'Creando habilidades...'
SKILLS_DATA = {
  programming: 'Programación',
  design: 'Diseño',
  analysis: 'Análisis',
  testing: 'Testing',
  management: 'Gestión de Proyectos',
  frontend: 'Frontend',
  backend: 'Backend',
  devops: 'DevOps',
  database: 'Base de Datos',
  mobile: 'Desarrollo Mobile'
}.freeze

skills = SKILLS_DATA.transform_values do |skill_name|
  find_or_create_by_name(Skill, skill_name)
end

# Datos de empleados
EMPLOYEES_DATA = [
  {
    name: 'Ana García',
    daily_hours: 8,
    skills: [:programming, :frontend, :backend],
  },
  {
    name: 'Carlos Rodríguez',
    daily_hours: 6,
    skills: [:design, :frontend],
  },
  {
    name: 'María López',
    daily_hours: 8,
    skills: [:analysis, :management, :testing],
  },
  {
    name: 'Juan Martínez',
    daily_hours: 7,
    skills: [:backend, :database, :devops],
  },
  {
    name: 'Laura Sánchez',
    daily_hours: 8,
    skills: [:mobile, :frontend, :testing],
  }
].freeze

# Creación de empleados y sus relaciones
puts 'Creando empleados y asignando habilidades...'
created_employees = EMPLOYEES_DATA.map do |employee_data|
  employee = find_or_create_by_name(Employee, employee_data[:name], 
                                   daily_hours: employee_data[:daily_hours])
  
  # Actualizar habilidades del empleado
  employee_skills = employee_data[:skills].map { |skill_key| skills[skill_key] }
  current_skills = employee.skills
  
  # Agregar nuevas habilidades
  (employee_skills - current_skills).each do |skill|
    EmployeeSkill.find_or_create_by!(employee: employee, skill: skill)
  end
  
  # Eliminar habilidades que ya no aplican
  (current_skills - employee_skills).each do |skill|
    employee.employee_skills.find_by(skill: skill)&.destroy
  end
  
  employee
end

# Creación o actualización de disponibilidades
puts 'Actualizando disponibilidades...'
date_range = (Date.today..30.days.from_now)

created_employees.each do |employee|
  date_range.each do |date|
    # Saltar fines de semana
    next if date.saturday? || date.sunday?
    
    # Crear o actualizar disponibilidad
    Availability.find_or_create_by!(employee: employee, date: date) do |availability|
      availability.available_hours = rand(4..employee.daily_hours)
    end
  end
  
  # Eliminar disponibilidades antiguas fuera del rango
  employee.availabilities.where.not(date: date_range).destroy_all
end
