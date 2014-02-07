class CreatePersonTasks < ActiveRecord::Migration
  def change
    create_table :person_tasks do |t|
      t.integer     :person_id
      t.integer     :task_id
      t.time        :start_time
      t.time        :end_time
      t.time        :total_time
      t.boolean     :is_submitted, :default => false
      t.boolean     :is_approved, :default => false
      t.integer     :role_id
      t.integer     :updated_by
      t.integer     :approved_by
      t.boolean     :is_overtime
      t.integer     :specific_task_id
      t.datetime    :shift_date
      
      t.timestamps
    end
  end
end
