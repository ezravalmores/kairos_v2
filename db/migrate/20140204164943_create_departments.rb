class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :description
      t.integer :organization_id
      
      t.timestamps
    end
  end
end
