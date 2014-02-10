class AddColumnOrganizationRoleToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :organization_role_id, :integer
  end

  def self.down
    remove_column :people, :organization__role_id, :integer
  end
end
