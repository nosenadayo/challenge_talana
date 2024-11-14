class AddUniqueIndexesToJoinTables < ActiveRecord::Migration[6.1]
  def change
    add_index :availabilities, [:employee_id, :date], unique: true, if_not_exists: true
    add_index :employee_skills, [:employee_id, :skill_id], unique: true, if_not_exists: true
    add_index :task_assignments, [:task_id, :assigned_date], unique: true, if_not_exists: true
    add_index :task_skills, [:task_id, :skill_id], unique: true, if_not_exists: true
  end
end