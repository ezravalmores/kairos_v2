class AddDateToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :date, :date
  end

  def self.down
    remove_column :activities, :date
  end
end
