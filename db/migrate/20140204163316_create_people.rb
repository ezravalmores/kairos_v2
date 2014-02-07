class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email_address
      t.string  :username
      t.string  :password
      t.boolean :is_active, :default => true
      t.integer :role_id
      t.integer :department_id
      t.time    :start_time
      t.time    :end_time
      t.boolean :can_approve
      t.decimal :remaining_vacation_leave
      t.decimal :remaining_sick_leave
      t.integer :organization_id
      t.string  :time_zone
      
      t.timestamps
    end
  end
end
