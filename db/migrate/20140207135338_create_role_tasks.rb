class CreateRoleTasks < ActiveRecord::Migration
  def change
    create_table :role_tasks do |t|
      t.integer :organization_id
      t.integer :department_id
      t.integer :role_id
      t.integer :task_id
    end
  end
end
