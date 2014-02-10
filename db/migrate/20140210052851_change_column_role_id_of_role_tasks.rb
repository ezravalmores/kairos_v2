class ChangeColumnRoleIdOfRoleTasks < ActiveRecord::Migration
  def self.up
    remove_column :role_tasks, :role_id
    add_column :role_tasks, :organization_role_id, :integer
  end
end
