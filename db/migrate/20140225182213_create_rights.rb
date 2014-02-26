class CreateRights < ActiveRecord::Migration
  def self.up
    create_table :rights do |t|
      t.string :action
      t.string :context
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rights
  end
end
