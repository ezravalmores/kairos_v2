class AddOrganizationIdToSpecificTasks < ActiveRecord::Migration
  def change
    add_column :specific_tasks, :organization_id, :integer
  end
end
