class AddToPersonTasks < ActiveRecord::Migration

  def self.up
    add_column :person_tasks, :person_in_charge, :string
    add_column :person_tasks, :note, :text   
  end

  def self.down
    remove_column :person_tasks, :person_in_charge, :string
    remove_column :person_tasks, :note, :text
  end
end
