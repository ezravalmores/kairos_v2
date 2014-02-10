class AddIsActiveToRoleTasks < ActiveRecord::Migration
  def change
    add_column :role_tasks, :is_active, :boolean, :default => true
  end
end
