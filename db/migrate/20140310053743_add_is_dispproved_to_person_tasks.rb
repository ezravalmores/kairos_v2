class AddIsDispprovedToPersonTasks < ActiveRecord::Migration
  def self.up
    add_column :person_tasks, :is_disapproved, :boolean, :default => false
  end

  def self.down
    remove_column :person_tasks, :is_disapproved
  end
end
