class AddForeignKeyToTasksWorkspace < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :tasks, :workspaces
  end
end
