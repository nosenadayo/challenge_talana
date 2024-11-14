class AddUniqueIndexToSkillName < ActiveRecord::Migration[6.1]
  def up
    add_index :skills, :name, unique: true, if_not_exists: true
  end
  
  # En caso de rollback, eliminamos el índice
  def down
    remove_index :skills, :name, if_exists: true
  end
end 