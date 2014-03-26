class AddPeopleNotifiedToLeaves < ActiveRecord::Migration
  def self.up
    add_column :leaves, :notified_people, :string
  end

  def self.down
    remove_column :leaves, :notified_people
  end
end
