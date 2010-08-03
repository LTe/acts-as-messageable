class CreateMessagesTable < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :topic
      t.string :body
      t.references :messageable, :polymorphic => true
      t.integer :from
      t.integer :to
    end

    add_index :messages, [:from, :to]
  end

  def self.down
    drop_table :messages
  end
end