class AddHasSeenOnActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :has_seen, :boolean, :default => false
  end

  def self.down
    remove_column :activities, :has_seen
  end
end
