class CreateRoleSpecificTasks < ActiveRecord::Migration
  def change
    create_table :role_specific_tasks do |t|
      t.integer :organization_id
      t.integer :department_id
      t.integer :role_task_id
      t.integer :specific_task_id
    end
  end
end
