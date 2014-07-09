class AddIsSubmittedToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :is_submitted, :boolean, :default => false
  end

  def self.down
    remove_column :events, :is_submitted
  end
end
