class CreateTaskAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :task_assignments do |t|
      t.references :task, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.date :assigned_date

      t.timestamps
    end
  end
end
