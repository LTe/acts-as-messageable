# typed: ignore
class AddRecipientPermanentDeleteAndSenderPermanentDeleteToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :<%= table_name %>, :recipient_permanent_delete, :boolean, default: false
    add_column :<%= table_name %>, :sender_permanent_delete, :boolean, default: false
  end
end
