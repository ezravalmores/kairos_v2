class CreateOrganizationRole < ActiveRecord::Migration
  def change
    create_table :organization_roles do |t|
      t.integer :organization_id
      t.string :name
      t.string :description
    end
  end
end
