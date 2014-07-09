class AddFromAndToToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :from, :date
    add_column :events, :to, :date
  end

  def self.down
    remove_column :events, :from
    remove_column :events, :to
  end
end
