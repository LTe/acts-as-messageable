class AddRecipientPermanentDeleteAndSenderPermanentDeleteToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :recipient_permanent_delete, :boolean, :default => false
    add_column :messages, :sender_permanent_delete, :boolean, :default => false
  end

  def self.down
    remove_column :messages, :recipient_permanent_delete
    remove_column :messages, :sender_permanent_delete
  end
end
