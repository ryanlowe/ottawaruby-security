class AddUsersLastTouchedAt < ActiveRecord::Migration
  def self.up
    add_column :users, :last_touched_at, :datetime, :default => nil
  end

  def self.down
    remove_column :users, :last_touched_at
  end
end
