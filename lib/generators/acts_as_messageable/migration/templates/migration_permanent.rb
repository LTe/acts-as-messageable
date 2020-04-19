class AddRecipientPermanentDeleteAndSenderPermanentDeleteToMessages < ActiveRecord::Migration
  def self.up
    add_column :<%= table_name %>, :recipient_permanent_delete, :boolean, :default => false
    add_column :<%= table_name %>, :sender_permanent_delete, :boolean, :default => false
  end

  def self.down
    remove_column :<%= table_name %>, :recipient_permanent_delete
    remove_column :<%= table_name %>, :sender_permanent_delete
  end
end
