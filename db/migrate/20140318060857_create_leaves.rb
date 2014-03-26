class CreateLeaves < ActiveRecord::Migration
  def self.up
    create_table :leaves do |t|
      
      t.integer :leave_type_id
      t.integer :person_id
      t.date :date
      t.text :reason
      t.boolean :is_approve, :default => false
      t.integer :approve_by
      t.boolean :is_submitted, :default => false
      t.boolean :is_active, :default => true
      t.boolean :is_canceled, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :leaves
  end
end
