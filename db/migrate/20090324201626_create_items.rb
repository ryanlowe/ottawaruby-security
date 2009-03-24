class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.timestamps
      t.integer :created_by
      t.string  :name
    end
  end

  def self.down
    drop_table :items
  end
end
