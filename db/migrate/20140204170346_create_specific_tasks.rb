class CreateSpecificTasks < ActiveRecord::Migration
  def change
    create_table :specific_tasks do |t|
       t.string :name
       t.integer :department_id
       t.integer :task_id
       t.string :description
       t.boolean :is_active, :default => true
    end
  end
end
