class CreateAvailabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :availabilities do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :date
      t.decimal :available_hours

      t.timestamps
    end
  end
end
