class AddIsActiveToSpecificRoleTask < ActiveRecord::Migration
  def change
    add_column :role_specific_tasks, :is_active, :boolean, :default => true
  end
end
