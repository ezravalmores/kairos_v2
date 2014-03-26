class AddIsDisApproveToLeaves < ActiveRecord::Migration
  def self.up
    add_column :leaves, :is_disapprove, :boolean, :default => false
  end

  def self.down
    remove_column :leaves, :is_disapprove
  end
end
