class CreateTaskSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :task_skills do |t|
      t.references :task, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
