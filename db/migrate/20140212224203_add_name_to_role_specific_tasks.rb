class AddNameToRoleSpecificTasks < ActiveRecord::Migration
  def change
    add_column :role_specific_tasks, :name, :string
  end
end
