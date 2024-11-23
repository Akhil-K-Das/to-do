class ChangeWorkspaceIdInTaksToBigint < ActiveRecord::Migration[7.2]
  def change
    change_column :tasks , :workspace_id, :bigint
  end
end
