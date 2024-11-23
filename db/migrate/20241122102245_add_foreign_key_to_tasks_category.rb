class AddForeignKeyToTasksCategory < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :tasks, :categories
  end
end
