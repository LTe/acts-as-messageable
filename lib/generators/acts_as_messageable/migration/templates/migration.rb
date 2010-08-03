class CreateMessagesTable < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :topic
      t.string :body
      t.references :received_messageable, :polymorphic => true
      t.references :sent_messageable, :polymorphic => true
    end

    add_index :messages, [:sent_messageable_id, :received_messageable_id]
  end

  def self.down
    drop_table :messages
  end
end