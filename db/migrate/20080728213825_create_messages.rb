class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :deleted_at
      t.integer  :sent_by
      t.integer  :sent_to
      t.datetime :replied_at
      t.integer  :in_reply_to
      t.string   :subject
      t.text     :body
      t.datetime :read_at
    end
  end

  def self.down
    drop_table :messages
  end
end
