class AddOrganizationRoleIdToRoleSpecificTasks < ActiveRecord::Migration
  def change
    add_column :role_specific_tasks, :organization_role_id, :integer
  end
end
