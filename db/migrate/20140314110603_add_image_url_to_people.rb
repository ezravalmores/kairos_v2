class AddImageUrlToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :image_url, :text
  end

  def self.down
    remove_column :people, :image_url
  end
end
