class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :name
      t.decimal :daily_hours

      t.timestamps
    end
  end
end
