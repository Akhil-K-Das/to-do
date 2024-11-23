class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.date :due_date
      t.integer :priority
      t.datetime :remind_before_at
      t.integer :assignee
      t.boolean :completion_status
      t.integer :category_id
      t.integer :workspace_id

      t.timestamps
    end
  end
end
