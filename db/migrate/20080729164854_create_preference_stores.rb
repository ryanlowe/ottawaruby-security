class CreatePreferenceStores < ActiveRecord::Migration
  def self.up
    create_table :preference_stores do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
      t.boolean  :notify_new_message, :default => true
    end
  end

  def self.down
    drop_table :preference_stores
  end
end
