class CreateWorkspaceUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :workspace_users do |t|
      t.references :workspace, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
