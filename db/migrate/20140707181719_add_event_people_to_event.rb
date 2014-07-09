class AddEventPeopleToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :event_people, :string
  end

  def self.down
    remove_column :events, :event_people
  end
end
